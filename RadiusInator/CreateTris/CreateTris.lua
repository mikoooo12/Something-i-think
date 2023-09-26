return function(A, B, C)
	local AB, AC, BC = B - A, C - A, C - B
	local ABD, ACD, BCD = AB:Dot(AB), AC:Dot(AC), BC:Dot(BC)

	local SwapA, SwapB
	if (ABD > ACD and ABD > BCD) then
		SwapA, SwapB = C, A
	elseif (ACD > BCD and ACD > ABD) then
		SwapA, SwapB = A, B
	end

	if SwapA and SwapB then
		A, B = SwapB, SwapA
		AB, AC, BC = B - A, C - A, C - B
	end

	local Right = AC:Cross(AB).unit
	local Up = BC:Cross(Right).unit
	local Back = BC.unit

	local Height = math.abs(AB:Dot(Up))

	return 
		{
			CFrame.fromMatrix((A + B)/2, Right, Up, Back),
			Vector3.new(0, Height, math.abs(AB:Dot(Back)))
		},
		{
			CFrame.fromMatrix((A + C)/2, -Right, Up, -Back),
			Vector3.new(0, Height, math.abs(AC:Dot(Back)))
		}
end
