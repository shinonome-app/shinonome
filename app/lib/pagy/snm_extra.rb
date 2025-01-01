# frozen_string_literal: true

require 'pagy/extras/js_tools'

class Pagy # :nodoc:
  # Frontend modules are specially optimized for performance.
  # The resulting code may not look very elegant, but produces the best benchmarks
  module SnmExtra
    # Pagination for snm elements: it returns the html with the series of links to the pages
    def pagy_snm_nav(pagy)
      link = pagy_anchor(pagy)
      link_arrow = pagy_anchor(pagy)

      html = +%(<nav>)
      html << %(<ul class="#{pagy_ul_class}">)
      html << pagy_snm_prev_html(pagy, link_arrow)
      pagy.series.each do |item| # series example: [1, :gap, 7, 8, "9", 10, 11, :gap, 36]
        html << case item
                when Integer
                  %(<li class="#{pagy_link_class}">#{link.call item}</li>)
                when String
                  %(<li class="#{pagy_li_class}">#{item}</li>)
                when :gap
                  %(<li class="#{pagy_gap_class}"><span>#{pagy_t 'pagy.gap'}</span></li>)
                else raise InternalError, "expected item types in series to be Integer, String or :gap; got #{item.inspect}"
                end
      end
      html << pagy_snm_next_html(pagy, link_arrow)
      html << %(</ul></nav>)
    end

    private

    def pagy_link_class
      'h-7 w-8 bg-ab_lightgray text-sm text-black flex wrap justify-center items-center hover:bg-blue-100'
    end

    def pagy_ul_class
      'flex gap-2 items-center'
    end

    def pagy_li_class
      'h-7 w-8 rounded text-sm overflow-hidden bg-ab_navy text-white flex wrap justify-center items-center'
    end

    def pagy_gap_class
      'h-7 w-8 bg-ab_lightgray text-sm text-black flex wrap justify-center items-center'
    end

    def pagy_snm_prev_html(pagy, link)
      if (p_prev = pagy.prev)
        %(<li><span>#{link.call p_prev, pagy_t('pagy.prev'), aria_label: 'previous'}</span></li>)
      else
        # %(<li><span>#{pagy_t 'pagy.prev'}</span></li>)
        ''
      end
    end

    def pagy_snm_next_html(pagy, link)
      if (p_next = pagy.next)
        %(<li><span>#{link.call p_next, pagy_t('pagy.next'), aria_label: 'next'}</span></li>)
      else
        # %(<li><span>#{pagy_t 'pagy.next'}</span></li>)
        ''
      end
    end
  end
  Frontend.prepend SnmExtra
end
