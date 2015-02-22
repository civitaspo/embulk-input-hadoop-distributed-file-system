require 'json'

module Embulk
  module Input

    class HadoopDistributedFileSystemInputPlugin < InputPlugin
      Plugin.register_input "hadoop-distributed-file-system", self

      AllowedFileFormat = ['tsv', 'json']

      class FileFormatNotAllowedError < StandardError; end

      def self.transaction config, &control
        # configuration code:
        threads         = config.param 'threads',         :integer, default: 1
        hadoop_home     = config.param 'hadoop_home',     :string
        hdfs_input_path = config.param 'hdfs_input_path', :string
        file_format     = config.param 'file_format',     :string, default: 'tsv'
        max_line_size   = config.param 'max_line_size',   :integer, default: 5_242_880
        schema          = config.param 'schema',          :array,   default: []

        raise FileFormatNotAllowedError.new("this file format is not allowed: #{file_format}") unless AllowedFileFormat.any?{|f| f == file_format}

        task    = {
                    'hadoop_home'     => hadoop_home,
                    'hdfs_input_path' => hdfs_input_path,
                    'file_format'     => file_format,
                    'schema'          => schema,
                    'max_line_size'   => max_line_size,
                  }
        idx     = -1
        columns = schema.map do |c|
                    idx += 1
                    Column.new idx, c['name'], c['type'].to_sym
                  end

        resume task, columns, threads, &control
      end

      def self.resume task, columns, count, &control
        commit_reports   = yield task, columns, count
        p commit_reports

        next_config_diff = {}
        return next_config_diff
      end

      def init
        super
        # initialization code:
        @hadoop_home       = task['hadoop_home']
        #ENV['HADOOP_HOME'] = @hadoop_home
        #require 'hdfs_jruby'
        #require 'hdfs_jruby/file'

        @hdfs_input_path   = task['hdfs_input_path']
        @file_format       = task['file_format']
        @parser            = case @file_format
                             when %r{\Atsv\z}  then lambda {|line| line.split("\t") }
                             when %r{\Ajson\z} then lambda {|line| JSON.parse(line).values }
                             else raise FileFormatNotAllowedError.new("this file format is not allowed: #{@file_format}") 
                             end
        @schema            = task['schema']
        @max_line_size     = task['max_line_size']
      end

      def run
        #Hdfs::File.open @hdfs_input_path, 'r' do |hdfs_io|
        IO.popen "hadoop fs -cat #{@hdfs_input_path}", 'r' do |hdfs_io|
          hdfs_io.each_line @max_line_size do |line|
            line.chomp!
            values = @parser.call line
            idx    = -1
            page_builder.add(
                              @schema.map{|val|
                                idx += 1
                                v = values[idx]
                                v.to_i if val['type'] == 'long'
                                v
                              }
                            )
          end
        end
        page_builder.finish

        commit_report = {}
        return commit_report
      end
    end

  end
end
