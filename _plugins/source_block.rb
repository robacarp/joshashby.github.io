# frozen_string_literal: true
#
# Idea taken from Shime https://shime.sh/til/building-emphasized-code-blocks-in-jekyll
# This is mostly a modified copy-pasta of the Jekyll Highlight liquid block
# with the addition of a source link and line highlighting/emphasis

# Adds support for source location links.
module Jekyll
  module Tags
    class SourceBlock < Liquid::Block
      include Liquid::StandardFilters

      SYNTAX = /^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|".*"))?)*)$/.freeze

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @lang = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
        else
          raise SyntaxError, <<~MSG
            Syntax Error in tag 'source' while parsing the following markup:
            #{markup}
            Valid syntax: source <lang> [linenos] [caption]
          MSG
        end
      end
      LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze

      def render(context)
        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        code = super.to_s.gsub(LEADING_OR_TRAILING_LINE_TERMINATORS, "")

        output =
          case context.registers[:site].highlighter
          when "rouge"
            render_rouge(code)
          when "pygments"
            render_pygments(code, context)
          else
            render_codehighlighter(code)
          end

        rendered_output = add_code_tag(output)
        prefix + rendered_output + suffix
      end

      private

      OPTIONS_REGEX = %r!(?:\w="[^"]*"|\w=\w|\w)+!.freeze

      def parse_options(input)
        options = {}
        return options if input.empty?

        # Split along 3 possible forms -- key="<quoted list>", key=value, or key
        input.scan(OPTIONS_REGEX) do |opt|
          key, value = opt.split("=")
          # If a quoted list, convert to array
          if value&.include?('"')
            value.delete!('"')
            value = value.split
          end
          options[key.to_sym] = value || true
        end

        options[:linenos] = "inline" if options[:linenos] == true
        options
      end

      def render_rouge(code)
        formatter = ::Rouge::Formatters::HTMLLineHighlighter.new(
          ::Rouge::Formatters::HTML.new,
          highlight_lines: @highlight_options[:hl_lines].map(&:to_i),
          highlight_line_class: "hll"
        )

        lexer = ::Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        formatter.format(lexer.lex(code))
      end

      def render_codehighlighter(code)
        h(code).strip
      end

      def add_code_tag(code)
        code_attributes = [
          "class=\"language-#{@lang.to_s.tr('+', '-')}\"",
          "data-lang=\"#{@lang}\""
        ].join(' ')

        "<figure class=\"highlight\">#{add_location_tag}<pre><code #{code_attributes}>"\
        "<div class=\"emphasized\">#{code.chomp}</div></code></pre>#{add_figcaption_tag}</figure>"
      end

      def add_figcaption_tag
        caption = @highlight_options[:caption]

        return "" unless caption

        "<figcaption>#{caption.join " "}</figcaption>"
      end

      def add_location_tag
        location = @highlight_options[:location]&.first

        return "" unless location

        "<div class='source-location'>
          <a href='#{location}'>
            #{location.split(%r{/blob/.*?/}).last} &nearr;
          </a>
        </div>"
      end
    end
  end
end

Liquid::Template.register_tag('source', Jekyll::Tags::SourceBlock)
