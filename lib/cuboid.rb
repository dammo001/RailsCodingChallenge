
class Cuboid

	attr_reader :origin, :top, :bottom, :left, :right, :front, :back, :width, :height, :length

	def initialize(origin, length, width, height)
		raise "Can't have negative side lengths" if check_inputs(length,width,height)
		@origin, @length, @width, @height = origin, length, width, height
		find_and_check
	end

	def move_to!(origin) 
		@origin = origin 
		find_and_check
	end

	def vertices 
		[
			[@left, @bottom, @front], [@right, @bottom, @front], 
			[@left, @bottom, @back], [@right, @bottom, @back], 
			[@left, @top, @front], [@right, @top, @front], 
			[@left, @top, @back], [@right, @top, @back]
		] 
	end

	def rotate!(axis)
		case axis 
		when "x" 
			temp = @length 
			@length = @width
			@width = temp 
		when "y" 
			temp = @width 
			@width = @height 
			@height = temp
		when "z" 
			temp = @height
			@height = @length 
			@length = temp 
		else 
			raise "not an axis"
		end
		find_and_check
	end

	def intersects?(other) 
		raise "must be called on another cuboid" if other.class != Cuboid
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

	def find_and_check
		find_sides(@length, @width, @height) 
		check_position
	end

	def check_inputs(length, width, height)
		length <= 0 || width <= 0 || height <= 0
	end

	def find_sides(length, width, height) 
		x = @origin[0]
		y = @origin[1]
		z = @origin[2]

		@left = x - length/2.0
		@right = x + length/2.0
		@back = y - width/2.0
		@front = y + width/2.0
		@bottom = z - height/2.0
		@top = z + height/2.0
	end

	def check_position
		if @left < 0
			change_length = (0 - @left)
		else 
			change_length = 0
		end

		if @back < 0 
			change_width = (0 - @back)
		else
			change_width = 0
		end

		if @bottom < 0
			change_height = (0 - @bottom)
		else
			change_height = 0 
		end

		if (change_length > 0) || (change_width > 0) || (change_height > 0)
			move_to!([@origin[0] + change_length, @origin[1] + change_width, @origin[2] + change_height])
		end
	end
   
end