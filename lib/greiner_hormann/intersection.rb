module GreinerHormann
  class Intersection
    attr_accessor :x, :y, :to_source, :to_clip

    def initialize(s1, s2, c1, c2)
      self.x = self.y = self.to_source = self.to_clip = 0.0
      d = (c2.y - c1.y) * (s2.x - s1.x) - (c2.x - c1.x) * (s2.y - s1.y)
      return if d == 0

      self.to_source = ((c2.x - c1.x) * (s1.y - c1.y) - (c2.y - c1.y) * (s1.x - c1.x)) / d
      self.to_clip = ((s2.x - s1.x) * (s1.y - c1.y) - (s2.y - s1.y) * (s1.x - c1.x)) / d

      if valid
        self.x = s1.x + self.to_source * (s2.x - s1.x)
        self.y = s1.y + self.to_source * (s2.y - s1.y)
      end
    end

    def valid
      0 < to_source && to_source < 1 && 0 < to_clip && to_clip < 1
    end
  end
end
