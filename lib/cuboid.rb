
class Cuboid

	attr_reader :vertices, :origin, :top, :bottom, :left, :right, :front, :back 

	def initialize(origin, length, width, height)
		@origin = origin
		@length = length
		@width = width
		@height = height 
		find_sides(length, width, height) 
		find_vertices  
	end

	def move_to!(origin) 
		@origin = origin 
		find_sides(@length, @width, @height) 
		find_vertices
	end

#returns true if the two cuboids intersect each other.  False otherwise.
	def intersects?(other) 
		return not( 
			@top < other.bottom ||
	        @bottom > other.top ||
	        @left > other.right ||
	        @right < other.left ||
	        @front < other.back ||
	        @back > other.front 
        )  
	end

	private 

	def find_sides(length, width, height) 
		x = @origin[0]
		y = @origin[1]
		@top = y + height/2.0
		z = @origin[2]
		@bottom = y - height/2.0
		@left = x - width/2.0
		@right = x + width/2.0
		@front = z + length/2.0
		@back = z - length/2.0
	end

	def find_vertices 
		@vertices = [
			[@left, @bottom, @front], [@right, @bottom, @front], 
			[@left, @bottom, @back], [@right, @bottom, @back], 
			[@left, @top, @front], [@right, @top, @front], 
			[@left, @top, @back], [@right, @top, @back]
		] 
	end
   
end
