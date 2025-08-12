---
applyTo: "**/waybar/**"
---

# Waybar Configuration Rules

MANDATORY requirements for waybar configuration files to prevent CSS errors and ensure functionality.

## Critical CSS Requirements

- **SHALL NOT** use these unsupported properties: `transform`, `text-align`, `display: grid`, `flex-direction`, `position: absolute/fixed`, `z-index`, `float`
- **MUST** use only: `margin`, `padding`, `min-width`, `min-height`, `border-radius`, `background-color`, `color`, `font-size`, `opacity`, `transition`
- **MUST** test CSS changes by running `waybar` and checking for errors in output

## JSON Configuration Requirements

- **MUST** use `.jsonc` extension for config files
- **MUST** validate syntax: `jsonlint config.jsonc`
- **MUST** include fallback formats for network module: `format-wifi`, `format-ethernet`, `format-disconnected`

## Validation Requirements

- **MUST** test waybar startup without errors: `waybar --config config.jsonc`
- **MUST** verify no CSS property errors in waybar output logs

## Violation Consequences

- Files using forbidden CSS properties **WILL BE REJECTED**
- Files causing waybar startup errors **WILL BE REJECTED**

## Applies To

- `**/waybar/config.jsonc` - Configuration files
- `**/waybar/style.css` - Styling files
