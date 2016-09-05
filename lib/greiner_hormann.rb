require 'greiner_hormann/intersection'
require 'greiner_hormann/polygon'
require 'greiner_hormann/vertex'

module GreinerHormann
  def self.clip(poly_a, poly_b, source_forwards, clip_forwards)
    source = Polygon.new(poly_a)
    clip = Polygon.new(poly_b)
    source.clip(clip, source_forwards, clip_forwards)
  end

  def self.union(poly_a, poly_b)
    clip(poly_a, poly_b, false, false)
  end

  def self.intersection(poly_a, poly_b)
    clip(poly_a, poly_b, true, true)
  end

  def self.difference(poly_a, poly_b)
    clip(poly_a, poly_b, false, true)
  end
end
