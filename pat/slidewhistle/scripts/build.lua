function build(directory, config, params, level, seed)
  local count = #config.colorOptions

  if not params.colorIndex then
    params.colorIndex = sb.makeRandomSource(seed):randInt(count)
  end

  local option = config.colorOptions[(params.colorIndex % count) + 1]
  if option then
    config.inventoryIcon = config.inventoryIcon .. option
    config.largeImage = config.largeImage .. option
    config.paletteSwap = option
  end

  local label = root.assetJson("/items/categories.config:labels")[config.category]
  config.tooltipFields = config.tooltipFields or {}
  config.tooltipFields.toolLabel = label or config.category

  return config, params
end
