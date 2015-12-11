require 'cuboid'


describe Cuboid do

	before :each do 
		@random_cuboid = Cuboid.new([rand(5..10), rand(5..10), rand(5..10)], rand(1..5),rand(1..5), rand(1..5))
		@test_cuboid = Cuboid.new([2,2,2],2,2,2)
		@rotate_cuboid = Cuboid.new([3,3,3],1,2,3)
		@rotate_cuboid2 = Cuboid.new([4,4,4],2,2,4)
		@rotate_cuboid3 = Cuboid.new([1,1,2],1,2,3)
		@overlapped_cuboid = Cuboid.new([2,2,2],1,1,1)
		@overlapping_cuboid = Cuboid.new([2,2,2],3,3,3)
		@edge_cuboid = Cuboid.new([4,4,4],2,2,2)
		@close_cuboid = Cuboid.new([4,4,4],1.9,1.9,1.9)
	end

	describe "#new" do 
		it "takes parameters and returns a Cuboid object" do 
			expect(@random_cuboid).to be_an_instance_of Cuboid 
		end  
	end

	describe '#initialize' do 
		it "has an origin attribute" do 
			expect(@random_cuboid.origin).to be_an_instance_of Array 
		end
		it "computes sides correctly" do 
			expect(@random_cuboid.left).to eq(@random_cuboid.origin[0] - @random_cuboid.length/2.0)
			expect(@random_cuboid.right).to eq(@random_cuboid.origin[0] + @random_cuboid.length/2.0)
			expect(@random_cuboid.back).to eq(@random_cuboid.origin[1] - @random_cuboid.width/2.0)
			expect(@random_cuboid.front).to eq(@random_cuboid.origin[1] + @random_cuboid.width/2.0)
			expect(@random_cuboid.bottom).to eq(@random_cuboid.origin[2] - @random_cuboid.height/2.0)
			expect(@random_cuboid.top).to eq(@random_cuboid.origin[2] + @random_cuboid.height/2.0)
		end
		it "computes vertices" do 
			expect(@random_cuboid.vertices).to be_an_instance_of Array 
			expect(@random_cuboid.vertices.length).to eq(8)
		end
		it "doesn't accept negative lengths" do 
			expect{Cuboid.new([0,0,0],-1,2,3)}.to raise_error("Can't have negative side lengths")
			expect{Cuboid.new([0,0,0], 1,-2,3)}.to raise_error("Can't have negative side lengths")
			expect{Cuboid.new([0,0,0],1,2,-3)}.to raise_error("Can't have negative side lengths")
		end
	end
	describe '#move_to!' do 
		it "should move to a new origin" do 
			expect{@test_cuboid.move_to!([3,3,3])}.to change{@test_cuboid.origin}.from([2,2,2]).to([3,3,3])
		end
		it "recomputes sides correctly" do
			expect(@test_cuboid.left).to eq(@test_cuboid.origin[0] - @test_cuboid.length/2.0)
			expect(@test_cuboid.right).to eq(@test_cuboid.origin[0] + @test_cuboid.length/2.0)
			expect(@test_cuboid.back).to eq(@test_cuboid.origin[1] - @test_cuboid.width/2.0)
			expect(@test_cuboid.front).to eq(@test_cuboid.origin[1] + @test_cuboid.width/2.0)
			expect(@test_cuboid.bottom).to eq(@test_cuboid.origin[2] - @test_cuboid.height/2.0)
			expect(@test_cuboid.top).to eq(@test_cuboid.origin[2] + @test_cuboid.height/2.0)
		end 
		it "should not move to negative positions" do 
			expect{@test_cuboid.move_to!([-2,-2,-2])}.to_not change{@test_cuboid.origin}.from([2,2,2]).to([-2,-2,-2])
		end
	end
	describe "#rotate!" do 

		it "should accept x y or z" do 
			expect{@test_cuboid.rotate!("x")}.to_not raise_error
			expect{@test_cuboid.rotate!("y")}.to_not raise_error
			expect{@test_cuboid.rotate!("z")}.to_not raise_error
		end

		it "should fail with any other input" do 
			expect{@test_cuboid.rotate!("a")}.to raise_error("not an axis")
			expect{@test_cuboid.rotate!(5)}.to raise_error("not an axis")
			expect{@test_cuboid.rotate!(["x","y"])}.to raise_error("not an axis")
		end

		it "should correctly switch length and width" do 
			expect{@rotate_cuboid.rotate!("x")}.to change{@rotate_cuboid.length}.from(1).to(2)
			expect{@rotate_cuboid.rotate!("x")}.to change{@rotate_cuboid.width}.from(1).to(2)
		end

		it "should correctly switch width and height" do 
			expect{@rotate_cuboid.rotate!("y")}.to change{@rotate_cuboid.width}.from(2).to(3)
			expect{@rotate_cuboid.rotate!("y")}.to change{@rotate_cuboid.height}.from(2).to(3)
		end

		it "should correctly switch height and length" do 
			expect{@rotate_cuboid.rotate!("z")}.to change{@rotate_cuboid.height}.from(3).to(1)
			expect{@rotate_cuboid.rotate!("z")}.to change{@rotate_cuboid.length}.from(3).to(1)
		end

		it "should recompute vertices correctly" do 
			expect{@rotate_cuboid2.rotate!("z")}.to change{@rotate_cuboid2.vertices}.from(
			 [
			 [3.0, 2.0, 5.0],
			 [5.0, 2.0, 5.0],
			 [3.0, 2.0, 3.0],
			 [5.0, 2.0, 3.0],
			 [3.0, 6.0, 5.0],
			 [5.0, 6.0, 5.0],
			 [3.0, 6.0, 3.0],
			 [5.0, 6.0, 3.0]
			 ]
			).to(
			 [ 
			 [2.0, 3.0, 5.0],
			 [6.0, 3.0, 5.0],
			 [2.0, 3.0, 3.0],
			 [6.0, 3.0, 3.0],
			 [2.0, 5.0, 5.0],
			 [6.0, 5.0, 5.0],
			 [2.0, 5.0, 3.0],
			 [6.0, 5.0, 3.0]
			 ]
			)
		end

		it "should move to the closest viable origin if it's out of bounds" do 
			expect{@rotate_cuboid3.rotate!("z")}.to change{@rotate_cuboid3.origin}.from([1,1,2]).to([1.5,1,2])
		end
	end

	describe "#intersects" do 
		it "finds intersecting cuboids" do 
		end
		it "doesn't return an intersection for very close values" do 
		end
		it "doesn't return an intersection for cuboids that have similar values but do not overlap" do 
		end
		it "returns true when second cuboid overlaps" do 
		end
		it "returns true when second cuboid is overlapped" do 
		end

		it "returns false when cuboids do not intersect" do 
		end
		it "raises an error when called on a non cuboid" do 
		end
	end

end


