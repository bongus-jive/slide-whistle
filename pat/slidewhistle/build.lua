function build(directory, config, params, level, seed)
  local count = #config.colorOptions

  if not params.colorIndex then
    params.colorIndex = sb.makeRandomSource(seed):randInt(count)
  end

  local option = config.colorOptions[(params.colorIndex % count) + 1]
  if option then
    config.inventoryIcon = config.inventoryIcon .. option
    config.activeImage = config.activeImage .. option
    config.largeImage = config.largeImage .. option
    config.image = config.image .. option
  end

  return config, params
end
