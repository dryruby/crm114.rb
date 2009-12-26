require 'crm114/version'

module Classifier
  class CRM114
    CLASSIFICATION_TYPE = '<osb unique microgroom>'
    FILE_EXTENSION = '.css'
    CMD_CRM = '/usr/bin/env crm'
    OPT_LEARN = '-{ learn %s ( %s ) }'
    OPT_CLASSIFY = '-{ isolate (:stats:); classify %s ( %s ) (:stats:); match [:stats:] (:: :best: :prob:) /Best match to file .. \\(%s\\/([[:graph:]]+)\\%s\\) prob: ([0-9.]+)/; output /:*:best:\\t:*:prob:/ }'

    ##
    # Returns a string containg the installed CRM114 engine version in a
    # format such as "20060118-BlameTheReavers".
    #
    # @return [String, nil]
    def self.version
      $1 if IO.popen(CMD_CRM + ' -v', 'r') { |pipe| pipe.readline } =~ /CRM114, version ([\d\w\-\.]+)/
    end

    ##
    # Returns a new CRM114 classifier defined by the given _categories_.
    #
    # @param  [Array<#to_s>] categories
    # @option options [String] :path ('.')
    def initialize(categories, options = {})
      @categories = categories.to_a.collect { |category| category.to_s.to_sym }
      @path = File.expand_path(options[:path] || '.')
      @debug = options[:debug] || false
    end

    ##
    # Trains the classifier to consider the given _text_ to be a sample from
    # the set named by _category_.
    #
    # @param  [#to_s]  category
    # @param  [String] text
    # @return [void]
    def learn!(category, text, &block)
      cmd = CMD_CRM + " '" + (OPT_LEARN % [CLASSIFICATION_TYPE, css_file_path(category)]) + "'"
      puts cmd if @debug
      IO.popen(cmd, 'w') { |pipe| block_given? ? block.call(pipe) : pipe.write(text) }
    end

    alias_method :train!, :learn!

    ##
    # @raise  NotImplementedError
    # @return [void]
    def unlearn!(category, text, &block) # :nodoc:
      raise NotImplementedError.new('unlearning not supported at present')
    end

    alias_method :untrain!, :unlearn! #:nodoc:

    ##
    # Returns the classification of the provided _text_ as a tuple
    # containing the highest-probability category and a confidence indicator
    # in the range of 0.5..1.0.
    #
    # @param  [String] text
    # @return [Array(Symbol, Float)]
    def classify(text = nil, &block)
      files = @categories.collect { |category| css_file_path(category) }
      cmd = CMD_CRM + " '" + (OPT_CLASSIFY % [CLASSIFICATION_TYPE, files.join(' '), @path.gsub(/\//, '\/'), FILE_EXTENSION]) + "'"
      puts cmd if @debug
      result = IO.popen(cmd, 'r+') do |pipe|
        block_given? ? block.call(pipe) : pipe.write(text)
        pipe.close_write
        pipe.readline unless pipe.closed? || pipe.eof?
      end
      return [nil, 0.0] unless result && result.include?("\t")
      result = result.split("\t")
      [result.first.to_sym, result.last.to_f]
    end

    def method_missing(symbol, *args) # :nodoc:
      case symbol.to_s[-1]
        when ?!
          category = symbol.to_s.chop.to_sym
          return learn!(category, *args) if @categories.include?(category)
        when ?? # it's a predicate
          category = symbol.to_s.chop.to_sym
          return classify(*args).first == category if @categories.include?(category)
      end
      super
    end

    protected

      ##
      # @param  [String] file
      # @return [void]
      def self.create_css_file(file)
        cmd = CMD_CRM + " '" + (OPT_LEARN % [CLASSIFICATION_TYPE, file]) + "'"
        IO.popen(cmd, 'w') { |pipe| pipe.close }
      end

      ##
      # @param  [#to_s] category
      # @return [String]
      def css_file_path(category)
        File.join(@path, category.to_s + FILE_EXTENSION)
      end

  end
end
