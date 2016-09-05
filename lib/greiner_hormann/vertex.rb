module GreinerHormann
  class Vertex
    attr_accessor :x, :y, :next_node, :prev_node, :corresponding, :distance, :is_entry, :is_intersection, :visited

    def initialize(x, y)
      self.x = x
      self.y = y

      self.next_node = self.prev_node = self.corresponding = nil
      self.distance = 0.0
      self.is_entry = true
      self.is_intersection = self.visited = false
    end

    def self.create_intersection(x, y, distance)
      vert = Vertex.new(x, y)
      vert.distance = distance
      vert.is_intersection = true
      vert.is_entry = false
      vert
    end

    def visit
      self.visited = true
      if !corresponding.nil? && !corresponding.visited
        corresponding.visit
      end
    end

    def ==(v)
      x == v.x && y == v.y
    end

    def equals(v)
      self == v
    end

    def is_inside(poly)
      odd_nodes = false
      vert = poly.first
      next_n = vert.next_node

      loop do
        if (vert.y < y && next_n.y >= y || next_n.y < y && vert.y >= y) && (vert.x <= x || next_n.x <= x)
          odd_nodes ^= vert.x + (y - vert.y) / (next_n.y - vert.y) * (next_n.x - vert.x) < x
        end

        vert = vert.next_node
        next_n = vert.next_node || poly.first

        break if vert == poly.first
      end
      odd_nodes
    end
  end
end
