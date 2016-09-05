require 'greiner_hormann/intersection'
require 'greiner_hormann/polygon'
require 'greiner_hormann/vertex'

module GreinerHormann
  class << self
    def clip(poly_a, poly_b, source_forwards, clip_forwards)
      source = Polygon.new(poly_a)
      clip = Polygon.new(poly_b)
      source.clip(clip, source_forwards, clip_forwards)
    end

    def union(poly_a, poly_b)
      clip(poly_a, poly_b, false, false)
    end

    def intersection(poly_a, poly_b)
      clip(poly_a, poly_b, true, true)
    end

    def diff(poly_a, poly_b)
      clip(poly_a, poly_b, false, true)
    end
  end
end
