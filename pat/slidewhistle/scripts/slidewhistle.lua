require "/pat/slidewhistle/scripts/soundplayer.lua"
require "/scripts/rect.lua"
require "/scripts/vec2.lua"
require "/scripts/interp.lua"

function init()
  WhistleSound = SoundPlayer:new("whistle", 0.2)

  SlideOffset = animator.partProperty("slide", "slideOffset")
  PitchRange = config.getParameter("pitchRange")
  BackArmFrames = config.getParameter("backArmFrames", {})

  activeItem.setBackArmFrame(BackArmFrames[1])
  activeItem.setFrontArmFrame(config.getParameter("frontArmFrame"))
  activeItem.setArmAngle(math.rad(config.getParameter("armAngle", 0)))

  animator.resetTransformationGroup("whistle")
  animator.rotateTransformationGroup("whistle", math.rad(config.getParameter("whistleAngle", 0)))
  animator.setGlobalTag("paletteSwaps", config.getParameter("paletteSwap", ""))

  if not world.clientWindow then script.setUpdateDelta(0) end
end

function update(dt, fireMode)
  local firing = fireMode ~= "none"
  WhistleSound:update(firing)
  activeItem.setRecoil(firing)

  local aimPos = activeItem.ownerAimPosition()
  if self.aimPos then
    aimPos = vec2.lerp(0.12, self.aimPos, aimPos)
  end
  self.aimPos = aimPos

  local aimAngle, aimDir = activeItem.aimAngleAndDirection(0, aimPos)
  activeItem.setFacingDirection(aimDir)

  local window = world.clientWindow()
  local center = rect.center(window)
  local size = rect.size(window)
  
  local edge = distanceToEdge(size[1], size[2], aimAngle) * 0.75
  local m = edge * 0.25
  edge = edge - m
  local dist = world.magnitude(center, aimPos) - m
  local percent = math.min(1, math.max(0, dist / edge))

  local pitch = interp.linear(percent, PitchRange[1], PitchRange[2])
  WhistleSound:setPitch(pitch)

  local backArm = math.floor(percent * #BackArmFrames) + 1
  activeItem.setBackArmFrame(BackArmFrames[backArm])

  animator.resetTransformationGroup("slide")
  animator.translateTransformationGroup("slide", {SlideOffset * percent // 0.0625 * 0.0625, 0})
end

function distanceToEdge(w, h, a)
  local dx = math.abs(w / 2 / math.cos(a))
  local dy = math.abs(h / 2 / math.sin(a))
  return math.min(dx, dy)
end
