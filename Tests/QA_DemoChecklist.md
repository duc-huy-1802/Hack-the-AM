# QA Demo Checklist — Owner: Tri Nguyen

## Functional
- [ ] Speed 0–5 km/h → Scenic Mode activates
- [ ] Speed 6–10 km/h → Active Mode activates
- [ ] Speed 11+ km/h → Runner Mode activates
- [ ] Smooth transitions, no pop/freeze between modes
- [ ] Score resets between sessions
- [ ] Bluetooth connects to treadmill within 10 seconds
- [ ] Fallback manual input works if Bluetooth fails

## Comfort
- [ ] No nausea after 5-minute continuous session
- [ ] Horizon stays stable during jogging
- [ ] Obstacles don't require head turning
- [ ] HUD readable without losing running form

## Demo Script Validation
- [ ] Minute 0–1: Scenic Mode visible at walking pace
- [ ] Minute 1–2: Jog pace → Active Mode, no button pressed
- [ ] Minute 2–3: Sprint → Runner Mode erupts (crowd audio, obstacles)
- [ ] Minute 3–4: Slow down → Scenic Mode returns + recap screen
