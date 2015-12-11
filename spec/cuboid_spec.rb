require 'cuboid'


describe Cuboid do

	let (:random_cuboid) { Cuboid.new([rand(5..10), rand(5..10), rand(5..10)], rand(1..5),rand(1..5), rand(1..5)) }
	let (:test_cuboid) { Cuboid.new([3,3,3],1,2,3) }
	let (:test_cuboid2) { Cuboid.new([1,1,1],2,2,2) }
	let (:rotate_cuboid) { Cuboid.new([3,3,3],1,2,3) }
	let (:rotate_cuboid2) { Cuboid.new([4,4,4],2,2,4) }
	let (:rotate_cuboid3) { Cuboid.new([1,1,2],1,2,3) }
	let (:overlapped_cuboid) { Cuboid.new([2,2,2],1,1,1) }
	let (:overlapping_cuboid) { Cuboid.new([2,2,2],3,3,3) }
	let (:edge_cuboid) { Cuboid.new([3,3,3],2,2,2) }
	let (:close_cuboid) { Cuboid.new([4,4,4],3.9,3.9,3.9) }

	describe "#new" do 

		it "takes parameters and returns a Cuboid object" do 
			expect(random_cuboid).to be_an_instance_of Cuboid 
		end  

	end

	describe '#initialize' do 

		it "has an origin attribute" do 
			expect(random_cuboid.origin).to be_an_instance_of Array 
		end

		it "computes sides correctly" do 
			expect(random_cuboid.left).to eq(random_cuboid.origin[0] - random_cuboid.length/2.0)
			expect(random_cuboid.right).to eq(random_cuboid.origin[0] + random_cuboid.length/2.0)
			expect(random_cuboid.back).to eq(random_cuboid.origin[1] - random_cuboid.width/2.0)
			expect(random_cuboid.front).to eq(random_cuboid.origin[1] + random_cuboid.width/2.0)
			expect(random_cuboid.bottom).to eq(random_cuboid.origin[2] - random_cuboid.height/2.0)
			expect(random_cuboid.top).to eq(random_cuboid.origin[2] + random_cuboid.height/2.0)
		end

		it "computes vertices" do 
			expect(random_cuboid.vertices).to be_an_instance_of Array 
			expect(random_cuboid.vertices.length).to eq(8)
		end

		it "doesn't accept negative lengths" do 
			expect{Cuboid.new([0,0,0],-1,2,3)}.to raise_error("Can't have negative side lengths")
			expect{Cuboid.new([0,0,0], 1,-2,3)}.to raise_error("Can't have negative side lengths")
			expect{Cuboid.new([0,0,0],1,2,-3)}.to raise_error("Can't have negative side lengths")
		end

	end
	describe '#move_to!' do 

		it "should move to a new origin" do 
			expect{test_cuboid.move_to!([4,4,4])}.to change{test_cuboid.origin}.from([3,3,3]).to([4,4,4])
		end

		it "recomputes sides correctly" do
			expect(test_cuboid.left).to eq(test_cuboid.origin[0] - test_cuboid.length/2.0)
			expect(test_cuboid.right).to eq(test_cuboid.origin[0] + test_cuboid.length/2.0)
			expect(test_cuboid.back).to eq(test_cuboid.origin[1] - test_cuboid.width/2.0)
			expect(test_cuboid.front).to eq(test_cuboid.origin[1] + test_cuboid.width/2.0)
			expect(test_cuboid.bottom).to eq(test_cuboid.origin[2] - test_cuboid.height/2.0)
			expect(test_cuboid.top).to eq(test_cuboid.origin[2] + test_cuboid.height/2.0)
		end 

		it "should not move to negative positions" do 
			test_cuboid.move_to!([-2,-2,-2])
			expect(test_cuboid.origin).to_not eq([-2,-2,-2])
		end

	end
	describe "#rotate!" do 

		it "should accept x y or z" do 
			expect{test_cuboid.rotate!("x")}.to_not raise_error
			expect{test_cuboid.rotate!("y")}.to_not raise_error
			expect{test_cuboid.rotate!("z")}.to_not raise_error
		end

		it "should fail with any other input" do 
			expect{test_cuboid.rotate!("a")}.to raise_error("not an axis")
			expect{test_cuboid.rotate!(5)}.to raise_error("not an axis")
			expect{test_cuboid.rotate!(["x","y"])}.to raise_error("not an axis")
		end

		it "should correctly switch length and width" do 
			expect{rotate_cuboid.rotate!("x")}.to change{rotate_cuboid.length}.from(1).to(2)
			expect{rotate_cuboid.rotate!("x")}.to change{rotate_cuboid.width}.from(1).to(2)
		end

		it "should correctly switch width and height" do 
			expect{rotate_cuboid.rotate!("y")}.to change{rotate_cuboid.width}.from(2).to(3)
			expect{rotate_cuboid.rotate!("y")}.to change{rotate_cuboid.height}.from(2).to(3)
		end

		it "should correctly switch height and length" do 
			expect{rotate_cuboid.rotate!("z")}.to change{rotate_cuboid.height}.from(3).to(1)
			expect{rotate_cuboid.rotate!("z")}.to change{rotate_cuboid.length}.from(3).to(1)
		end

		it "should recompute vertices correctly" do 
			expect{rotate_cuboid2.rotate!("z")}.to change{rotate_cuboid2.vertices}.from(
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
			expect{rotate_cuboid3.rotate!("z")}.to change{rotate_cuboid3.origin}.from([1,1,2]).to([1.5,1,2])
		end

	end

	describe "#intersects" do 

		it "finds intersecting cuboids" do 
			expect(test_cuboid2.intersects?(rotate_cuboid3)).to be(true)
		end

		it "doesn't return an intersection for very close values" do 
			expect(test_cuboid2.intersects?(close_cuboid)).to be(false)
		end

		it "returns true when second cuboid overlaps" do 
			expect(test_cuboid2.intersects?(overlapping_cuboid)).to be(true)
		end

		it "returns true when second cuboid is overlapped" do 
			expect(test_cuboid2.intersects?(overlapped_cuboid)).to be(true)
		end

		it "returns false when cuboids do not intersect" do 
			expect(test_cuboid2.intersects?(test_cuboid)).to be(false)
		end

		it "raises an error when called on a non cuboid" do 
			expect{test_cuboid.intersects?("a")}.to raise_error("must be called on another cuboid")
			expect{test_cuboid.intersects?(2)}.to raise_error("must be called on another cuboid")
			expect{test_cuboid.intersects?([rotate_cuboid, rotate_cuboid2])}.to raise_error("must be called on another cuboid")
		end

	end

end