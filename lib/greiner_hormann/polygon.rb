module GreinerHormann
  class Polygon
    attr_accessor :first, :verticies, :last_unprocessed, :first_intersect

    def initialize(pnts)
      self.first = self.first_intersect = self.last_unprocessed = nil
      self.verticies = 0

      pnts.each do |pnt|
        add_vertex(Vertex.new(*pnt))
      end
    end

    def add_vertex(vert)
      if self.first.nil?
        self.first = vert
        self.first.next_node = vert
        self.first.prev_node = vert
      else
        next_n = self.first
        prev_n = next_n.prev_node

        next_n.prev_node = vert
        vert.next_node = next_n
        vert.prev_node = prev_n
        prev_n.next_node = vert
      end

      self.verticies += 1
    end

    def insert_vertex(vert, start, finish)
      curr_n = start

      while curr_n != finish && curr_n.distance < vert.distance
        curr_n = curr_n.next_node
      end

      vert.next_node = curr_n
      prev_n = curr_n.prev_node

      vert.prev_node = prev_n
      prev_n.next_node = vert
      curr_n.prev_node = vert

      self.verticies += 1
    end

    def get_next(v)
      c = v
      while c.is_intersection
        c = c.next_node
      end
      c
    end

    def get_first_intersect
      v = self.first_intersect || self.first

      loop do
        break if v.is_intersection && !v.visited
        v = v.next_node
        break if v == self.first
      end

      self.first_intersect = v
      v
    end

    def has_unprocessed
      v = self.last_unprocessed || self.first

      loop do
        if v.is_intersection && !v.visited
          self.last_unprocessed = v
          return true
        end

        v = v.next_node
        break if v == self.first
      end

      self.last_unprocessed = nil
      false
    end

    def get_points
      points = []
      v = self.first

      loop do
        points << [v.x, v.y]
        v = v.next_node
        break if v == self.first
      end

      points
    end

    # Clip polygon against another one.
    # Result depends on algorithm direction:
    #
    # Intersection: forwards forwards
    # Union:        backwars backwards
    # Diff:         backwards forwards
    def clip(clip, source_forwards, clip_forwards)
      source_vert = self.first
      clip_vert = clip.first

      loop do
        unless source_vert.is_intersection
          loop do
            unless clip_vert.is_intersection
              i = Intersection.new(source_vert, get_next(source_vert.next_node), clip_vert, clip.get_next(clip_vert.next_node))

              if i.valid
                source_intersection = Vertex.create_intersection(i.x, i.y, i.to_source)
                clip_intersection = Vertex.create_intersection(i.x, i.y, i.to_clip)
                source_intersection.corresponding = clip_intersection
                clip_intersection.corresponding = source_intersection

                insert_vertex(source_intersection, source_vert, get_next(source_vert.next_node))
                clip.insert_vertex(clip_intersection, clip_vert, clip.get_next(clip_vert.next_node))
              end
            end
            clip_vert = clip_vert.next_node
            break if clip_vert == clip.first
          end
        end

        source_vert = source_vert.next_node
        break if source_vert == self.first
      end

      source_vert = self.first
      clip_vert = clip.first

      source_in_clip = source_vert.is_inside(clip)
      clip_in_source = clip_vert.is_inside(self)

      source_forwards ^= source_in_clip
      clip_forwards ^= clip_in_source

      loop do
        if source_vert.is_intersection
          source_vert.is_entry = source_forwards
          source_forwards = !source_forwards
        end
        source_vert = source_vert.next_node
        break if source_vert == self.first
      end

      loop do
        if clip_vert.is_intersection
          clip_vert.is_entry = clip_forwards
          clip_forwards = !clip_forwards
        end
        clip_vert = clip_vert.next_node
        break if clip_vert == clip.first
      end

      list = []

      while has_unprocessed
        current = get_first_intersect
        clipped = Polygon.new([])
        clipped.add_vertex(Vertex.new(current.x, current.y))

        loop do
          current.visit
          if current.is_entry
            loop do
              current = current.next_node
              clipped.add_vertex(Vertex.new(current.x, current.y))
              break if current.is_intersection
            end
          else
            loop do
              current = current.prev_node
              clipped.add_vertex(Vertex.new(current.x, current.y))
              break if current.is_intersection
            end
          end
          current = current.corresponding
          break if current.visited
        end

        list << clipped.get_points
      end

      if list.length == 0
        list << self.get_points if source_in_clip
        list << clip.get_points if clip_in_source
        list = nil if list.length == 0
      end

      list
    end
  end
end
