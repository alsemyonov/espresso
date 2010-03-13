module Espresso
  module ActionView
    module Stats
      # Set online statistics trackers
      # @options
      def online_stats(options = {})
        static_includes = []
        dynamic_includes = ''
        noscript_includes = []
        initializers = []

        if piwik = options.delete(:piwik)
          static_includes   << "//#{piwik[:site]}/piwik.js"
          initializers      << "var piwikTracker=Piwik.getTracker('//#{piwik[:site]}/piwik.php',#{piwik[:id]});piwikTracker.trackPageView();piwikTracker.enableLinkTracking();"
          noscript_includes << "//#{piwik[:site]}/piwik.php?idsite=#{piwik[:id]}"
        end

        if metrika = options.delete(:metrika)
          static_includes   << '//mc.yandex.ru/resource/watch.js'
          initializers      << "var yaCounter#{metrika}=new Ya.Metrika(#{metrika});"
          noscript_includes << "//mc.yandex.ru/watch/#{metrika}"
        end

        if analytics = options.delete(:analytics)
          dynamic_includes << 'var gaJsHost=("https:"==document.location.protocol)?"https://ssl.":"http://www.";'
          dynamic_includes << 'document.write(unescape("%3Cscript src=\'"+gaJsHost+"google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3Ei"));'
          initializers     << "var pageTracker=_gat._getTracker('#{analytics}');pageTracker._trackPageview();"
        end

        returning('') do |result|
          unless dynamic_includes.empty?
            result << javascript_tag(dynamic_includes)
          end
          result << javascript_include_tag(static_includes) unless static_includes.empty?
          unless initializers.empty?
            initializers = initializers.collect do |initializer|
              "try {#{initializer}} catch(e) {}"
            end.join("\n")
            result << javascript_tag(initializers)
          end
          unless noscript_includes.empty?
            includes = noscript_includes.collect do |noscript|
              %(<img src="#{noscript}" style="border:0" alt="" />)
            end.join("\n")
            result << content_tag(:noscript,
                                  content_tag(:div,
                                              includes,
                                              :style => 'position: absolute'))
          end
        end
      end
    end
  end
end
