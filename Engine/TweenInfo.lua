local TweenInfo = {}

function TweenInfo.new(Duration, EasingStyle, EasingDirection, RepeatCount, Reverses, Delay)
    local self = {}

    self.Duration = Duration
    self.EasingStyle = EasingStyle
    self.EasingDirection = EasingDirection

    self.RepeatCount = RepeatCount
    self.Reverses = Reverses
    self.Delay = Delay


    return self
end

return TweenInfo
