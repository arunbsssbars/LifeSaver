import 'package:flutter/material.dart';

class SurvivalPlaybookScreen extends StatelessWidget {
  const SurvivalPlaybookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Text(
          'Disaster Survival Playbooks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.offline_pin_rounded, color: Color(0xFF10B981), size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '100% Offline Accessible',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'These protocols remain available even without internet or cellular connectivity.',
                        style: TextStyle(color: Colors.white54, fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _buildPlaybookCard(
            context: context,
            title: '🌊 River & Mountain Flash Floods',
            accentColor: const Color(0xFF38BDF8),
            summary: 'Action protocols for rapid inundation, river surges, and cloudbursts.',
            steps: [
              'Move immediately to high ground or the second floor of a concrete building. Do not wait for instructions if water is rising.',
              'Never walk, swim, or drive through moving water. Just 15 cm of rapid water can knock an adult down.',
              'Disconnect main electrical switches and gas cylinders before evacuating to prevent short circuits and explosions.',
              'Avoid riverbanks and bridges: Flash floods in Himalayan terrain often cause severe erosion and sudden bank collapses.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '⛰️ Landslides & Mudflows',
            accentColor: const Color(0xFFF59E0B),
            summary: 'Critical guidelines for hilly slopes, debris flows, and road blockages.',
            steps: [
              'Listen for unusual sounds such as trees cracking, boulders knocking together, or sudden muddy trickle in clear streams.',
              'If caught in a landslide, curl into a tight ball and protect your head with your hands/bag.',
              'Move laterally away from the direct downhill path of the mudflow or rockfall.',
              'Never return to a landslide site immediately after an event; secondary slides frequently follow.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🌀 Tropical Cyclones & Coastal Storm Surge',
            accentColor: const Color(0xFF0284C7),
            summary: 'IMD 4-Stage cyclone warning response and coastal inundation safety.',
            steps: [
              'Board up glass windows or put cross-tapes. Secure loose roof sheets, tin sheds, and solar panels.',
              'Move inland to an elevated cyclone shelter before landfall if living within 5 km of the coastline or tidal river mouth.',
              'Beware of the "Eye of the Cyclone": A sudden calm during the storm is temporary. Destructive gale winds will reverse direction rapidly.',
              'Fishermen must heed INCOIS total fishing ban. Anchor boats securely away from high-tide line.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '⚡ Earthquakes & Tremors',
            accentColor: const Color(0xFFEF4444),
            summary: 'Drop, Cover, and Hold On protocols for seismic events.',
            steps: [
              'DROP to your hands and knees. COVER your head and neck under a sturdy table or desk. HOLD ON until shaking stops.',
              'If outdoors, move away from buildings, power cables, old brick walls, and steep hill slopes.',
              'Do not use elevators. Expect and prepare for strong aftershocks within 24 to 72 hours.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🔥 Urban Fire & LPG Gas Leak Safety (NBC 2016)',
            accentColor: const Color(0xFFF97316),
            summary: 'National Building Code fire extinguisher protocols & PASS technique.',
            steps: [
              'Remember P-A-S-S: Pull safety pin, Aim nozzle at fire base, Squeeze lever, Sweep side-to-side.',
              'NEVER USE WATER on electrical or burning oil fires. Use CO₂ or ABC dry powder extinguisher.',
              'If LPG smell (rotten eggs) is detected: DO NOT operate electrical switches or matchsticks. Close cylinder regulator, open windows, and evacuate.',
              'Crawl low under smoke: Toxic carbon monoxide and superheated gases rise to the ceiling.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '☣️ Chemical / Industrial Toxic Gas Leak SOP',
            accentColor: const Color(0xFF8B5CF6),
            summary: 'NDMA industrial chemical and chlorine/ammonia leak guidelines.',
            steps: [
              'EVACUATE CROSSWIND (perpendicular to wind direction). Never run in the direction the wind is blowing the gas cloud.',
              'Place a wet cloth/towel over your mouth, nose, and eyes. Water dissolves and neutralizes ammonia and chlorine vapors.',
              'For heavy gases (Chlorine, LPG), climb to higher floors or rooftops. Do not seek shelter in basements.',
              'Do not consume open food or water exposed to chemical plumes. Wash skin thoroughly with clean water.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '⚡ Lightning & Thunderstorm Safety (Damini Protocol)',
            accentColor: const Color(0xFFFBBF24),
            summary: 'NDMA & Lightning Resilient India 30-30 rule and outdoor lightning crouch.',
            steps: [
              'Follow 30-30 Rule: If time between lightning flash and thunder is under 30 seconds, strike is within 10 km. Stay indoors for 30 minutes after the last thunder.',
              'NEVER seek shelter under solitary tall trees, tin sheds, metal poles, or wire fences (Side-flash & touch voltage hazard).',
              'If trapped in an open field: Adopt the "LIGHTNING CROUCH" (crouch low on balls of feet with heels touching, hands over ears, head tucked). NEVER lie flat on the ground.',
              'Avoid metal plumbing, corded phones, and electrical appliances during active lightning storms.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '☀️ Severe Heatwave (Loo) & Cold Wave Action Plan',
            accentColor: const Color(0xFFEF4444),
            summary: 'NDMA Heatwave guidelines, ORS rehydration, and hypothermia precautions.',
            steps: [
              'Avoid afternoon sun exposure (11 AM - 4 PM). Drink ORS, Chaas, Lassi, Nimbu Paani, and Aam Panna frequently.',
              'Never leave children or elderly inside parked cars (temperatures surge to fatal levels in minutes).',
              'Heat Stroke First Aid: Move victim to shade, apply ice packs/wet cloth to armpits/neck/groin, call 108 immediately.',
              'Cold Wave & Angithi Safety: Maintain room cross-ventilation when using coal heaters/charcoal fires to prevent fatal Carbon Monoxide asphyxiation.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🌊 Coastal Tsunami & Inundation (ITEWC / INCOIS)',
            accentColor: const Color(0xFF06B6D4),
            summary: 'Tsunami warning protocol, deep sea rules, and 20m high-ground evacuation.',
            steps: [
              'If you feel strong shaking near the coast or observe sudden sea drawback exposing sea floor, EVACUATE TO HIGH GROUND IMMEDIATELY (at least 20m high or 2km inland).',
              'Never wait for sirens or go to the beach to watch incoming waves.',
              'Boats in deep ocean (>100m depth) must stay out at sea; do not return to shallow harbors where wave energy builds up.',
              'Tsunamis consist of a series of waves over several hours; the first wave is rarely the largest.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🏔️ Glacial Lake Outburst Flood (GLOF - Himalayan Belts)',
            accentColor: const Color(0xFF38BDF8),
            summary: 'Moraine dam breach survival, high-altitude surge wave alerts.',
            steps: [
              'If living downstream of high-altitude glacial lakes, monitor automated warning sirens and river gauge anomalies.',
              'Upon GLOF breach alert, move up valley slopes at least 50m above river bed level immediately.',
              'Do not use low-lying river bridges or culverts; high-velocity boulder debris flows destroy bridges in seconds.',
              'Store non-perishable rations and satellite/radio comms on elevated mountain terraces.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '☢️ Nuclear & Radiation Protection (DAE / AERB / NDMA)',
            accentColor: const Color(0xFFA855F7),
            summary: 'Time, Distance, Shielding principles and Potassium Iodide (KI) protocols.',
            steps: [
              'Apply Golden Triad: Minimize TIME in plume, maximize DISTANCE, utilize dense SHIELDING (concrete/brick basements).',
              'Turn off all split AC units, ventilation fans, and seal doors/windows with plastic sheets and tape.',
              'Decontamination: Remove and double-bag outer clothing (eliminates 90% of fallout). Wash hair gently with soap (NO conditioner).',
              'Take Potassium Iodide (KI) ONLY when ordered by public health officials to block radioactive iodine uptake in thyroid.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🌫️ Air Pollution & GRAP Smog Emergency (CPCB / CAQM)',
            accentColor: const Color(0xFF64748B),
            summary: 'National Air Quality Index (NAQI) safeguards and N95 respiratory protection.',
            steps: [
              'When AQI exceeds 300 (Very Poor / Severe), wear certified N95 or FFP2 respirators outdoors.',
              'Avoid early morning jogging or strenuous physical activity during winter temperature inversion periods.',
              'Comply with Graded Response Action Plan (GRAP) bans on open biomass burning and diesel generator operation.',
              'Asthma/bronchitis patients must carry SOS inhalers and maintain clean indoor HEPA air filtration.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🦠 Post-Flood Epidemic & Waterborne Disease Control (NCDC)',
            accentColor: const Color(0xFF14B8A6),
            summary: 'Chlorine disinfection, Leptospirosis, Cholera prevention, and ORS recipes.',
            steps: [
              'Water Disinfection: Add 1 NaDCC Halogen tablet (33mg) per 5L of clear water; wait 30 minutes before drinking.',
              'Never wade barefoot in stagnant post-flood waters (prevents fatal Leptospirosis/Rat Fever entry via skin abrasions).',
              'Prepare WHO ORS (1 sachet per 1L water) or Homemade SSS (6 tsp sugar + 1/2 tsp salt in 1L clean boiled water) for acute diarrhea.',
              'Empty all discarded containers and water coolers weekly to prevent Aedes mosquito dengue breeding.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🐄 Animal & Livestock Disaster Rescue & Snakebites',
            accentColor: const Color(0xFF84CC16),
            summary: 'Untying cattle SOPs, emergency fodder, and Anti-Snake Venom (ASV) rules.',
            steps: [
              'CRITICAL: UNTIE all livestock during floods and cyclone storm surges; tied cattle drown helplessly.',
              'Herd livestock to designated high-ground cattle shelters (Pashu Rahat Shivir) with elevated dry fodder stores.',
              'Snakebite First Aid: IMMOBILIZE bitten limb with splint at heart level and rush to CHC/Hospital for Anti-Snake Venom (ASV).',
              'NEVER apply tourniquets, incisions, suction, or herbal pastes to snakebite wounds.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🧠 Psychological First Aid & Panic Control (NIMHANS)',
            accentColor: const Color(0xFFEC4899),
            summary: 'Look-Listen-Link framework, 5-4-3-2-1 grounding, and 4-4-4-4 box breathing.',
            steps: [
              '5-4-3-2-1 Grounding: Identify 5 things you see, 4 you feel, 3 you hear, 2 you smell, and 1 positive fact.',
              'Box Breathing: Inhale 4s, Hold 4s, Exhale 4s, Hold 4s. Repeat 5 cycles to lower acute panic heart rate.',
              'Look-Listen-Link: Provide basic safety and shelter first, listen without judgement, link survivors with family and relief teams.',
              'Avoid spreading unverified social media catastrophe rumors that trigger mass crowd panics.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '📻 Amateur HAM Radio Emergency Comms (WPC / NDMA)',
            accentColor: const Color(0xFFF59E0B),
            summary: 'Disaster frequencies (40m HF 7.050 MHz / 2m VHF 145.500 MHz) & Q-Codes.',
            steps: [
              'Monitor IARU National Disaster Net on 7.050 MHz (40m HF LSB) for inter-state emergency traffic during cellular blackout.',
              'Use 145.500 MHz (2m VHF FM) for local tactical distress calls and Aapda Mitra coordination.',
              'Standard Q-Codes: QTH = Location, QRT = Cease transmission / Silence for emergency, QRX = Standby.',
              'Keep battery packs charged with auxiliary solar panels for continuous HAM radio readiness.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '♿ Divyangjan Disability-Inclusive Evacuation (NDMA DiDRR)',
            accentColor: const Color(0xFF6366F1),
            summary: 'Accessible evacuation SOPs for locomotor, visual, deaf, and medical-dependent persons.',
            steps: [
              'Never separate a person with locomotor disability from their wheelchair, walker, or prosthetic device.',
              'Visual Impairment: Verbally announce obstacles and offer elbow for sighted guide; never pull wrists.',
              'Deaf / Hard of Hearing: Use high-intensity flashing LED strobes and bold written cards for disaster alerts.',
              'Cold-Chain Medications: Carry insulin and vital biologics in insulated ice-pack vaccine carriers (2°C - 8°C).',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🌲 Forest Fire & Ridge Wildfire Survival (FSI Van Agni)',
            accentColor: const Color(0xFFF97316),
            summary: 'Hill slope fireline clearance, uphill evacuation hazards, and ember traps.',
            steps: [
              'Create a 15–30 meter fuel-free defensible perimeter around hill settlements by clearing dry pine needles (Chir Pine/Pirul).',
              'Never try to outrun a forest fire uphill: Fires spread uphill exponentially faster because rising heat preheats upper slope fuels.',
              'If trapped, seek natural rocky outcrops, wide cleared roads, or previously burned patches (black zone).',
              'Cover face with wet cotton cloth to protect bronchial airways from superheated ash and smoke asphyxiation.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '⛵ Inland River Ghat & Boat Capsize Safety (IWAI / NDMA)',
            accentColor: const Color(0xFF0284C7),
            summary: 'Overcrowding prevention, lifejacket mandate, and cold water survival.',
            steps: [
              'NEVER board an overcrowded ferry or country boat lacking sufficient lifejackets for all passengers.',
              'If boat begins capsizing: Jump clear to the upstream side to avoid getting trapped beneath the hull or entangled in ropes.',
              'Adopt the HELP (Heat Escape Lessening Posture) floating position: Cross arms over chest, draw knees to chin to preserve core body heat.',
              'Stay clear of hydraulic jumps, weir spillways, and bridge pier whirlpools where downward suction is fatal.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🚗 Winter Dense Fog & Expressway Pileup Prevention (NHAI)',
            accentColor: const Color(0xFF94A3B8),
            summary: 'Low-beam navigation, 4-second headway spacing, and emergency pull-off rules.',
            steps: [
              'When visibility drops below 50m (Dense Fog), reduce speed to 30 km/h and turn on yellow fog lamps.',
              'NEVER use high-beam headlights (creates blinding glare). Follow left shoulder continuous white line markings.',
              'DO NOT stop in the center carriageway of an expressway. Pull completely off into toll plazas or fuel stations.',
              'Maintain at least a 4-second following distance to allow emergency braking on slick cold asphalt.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🩹 Burn & Blast Trauma First Aid (Parkland Formula)',
            accentColor: const Color(0xFFEF4444),
            summary: 'Cool water cooling, sterile covering, and chemical burn copious flushing.',
            steps: [
              'Cool thermal burns immediately under clean, cool running water for 15–20 minutes. DO NOT use ice or ice water.',
              'DO NOT apply turmeric, butter, oils, or toothpaste. Cover loosely with clean plastic cling film or sterile gauze.',
              'Chemical burns: Flush with copious flowing water for a minimum of 30 minutes continuously.',
              'Blast injuries: Immediately apply direct pressure or windlass tourniquets for severe limb arterial bleeding.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '⚡ Black Sky Grid Collapse & Power Blackout Survival (CEA)',
            accentColor: const Color(0xFFFBBF24),
            summary: 'Food preservation, voltage surge isolation, and critical life support priority.',
            steps: [
              'Keep refrigerators and deep freezers strictly closed (preserves perishable food safety for up to 48 hours).',
              'Unplug expensive electronic appliances to prevent destruction from massive transient voltage spikes upon power restoration.',
              'Use LED lanterns instead of open wax candles in disaster zones to prevent accidental structural fires.',
              'Conserve smartphone battery: Switch to Ultra Battery Saver, disable background Bluetooth/GPS, and reduce brightness.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '👥 Crowd Crush & Stampede Prevention (NDMA Boxer Stance)',
            accentColor: const Color(0xFFEC4899),
            summary: 'Boxer stance protective breathing pocket, surge flow navigation, and fetal roll.',
            steps: [
              'Adopt the BOXER STANCE: Place hands in front of chest with elbows flexed to create a 10 cm breathing cage protecting your lungs.',
              'Do not fight against crowd momentum or push back; drift diagonally with the crowd towards perimeter walls or open exits.',
              'If you drop belongings (phone, shoes), DO NOT bend down to retrieve them in dense crowd surges.',
              'If knocked down: Curl into a tight ball on your left side with arms shielding your skull and chest.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🏜️ Severe Dust Storms & Andhi / Haboob (IMD)',
            accentColor: const Color(0xFFD97706),
            summary: 'Aerosol surge protection, eye sealing, and highway pull-off parking.',
            steps: [
              'When convective dust storms (Andhi) strike: Seek permanent brick/RCC structure. Close all windows and AC intakes.',
              'Wear airtight goggles and N95 masks to prevent corneal abrasions and acute PM10 inhalation trauma.',
              'Highway motorists: Pull completely off the paved road, switch off all headlights, set parking brake, and keep foot off brake pedal.',
              'Stay away from tin sheds, temporary hoardings, and mature eucalyptus trees which collapse under 70+ km/h microburst winds.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '☣️ HAZMAT Transport Spill & UN Guide (PESO / CMVR)',
            accentColor: const Color(0xFFDC2626),
            summary: 'HAZCHEM Emergency Action Codes (EAC), 500m isolation, and toxic plume standoff.',
            steps: [
              'Check the 3-digit Emergency Action Code (EAC) on the rear diamond placard (e.g. 2WE, 3YE, 2RE) before approaching.',
              'Maintain an immediate 500m upwind isolation perimeter for toxic gas or flammable liquid tanker breaches.',
              'DO NOT spray high-pressure solid water streams directly onto chemical containers (use wide water fog curtain to knock down vapors).',
              'First responders must don appropriate Level A/B encapsulated chemical suits and positive-pressure SCBA.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '❄️ Extreme Cold Hypothermia & Frostbite Rewarming (ITBP)',
            accentColor: const Color(0xFF38BDF8),
            summary: '37°C–40°C warm water immersion, no-snow-rubbing rule, and core torso insulation.',
            steps: [
              'NEVER rub frostbitten extremities with snow or dry cloth (causes microscopic ice shards to tear living cells).',
              'RAPID REWARMING: Submerge frostbitten hands/feet in warm water maintained between 37°C and 40°C for 20–30 minutes until skin softens and turns pink.',
              'Do not rewarm if there is any chance of tissue refreezing before reaching hospital.',
              'Insulate core: Apply warm packs to groin, axillae (armpits), and neck; cover head with windproof balaclava.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🏔️ High-Altitude Sickness & HAPE/HACE (ITBP / AMC)',
            accentColor: const Color(0xFF6366F1),
            summary: 'Lake Louise AMS triage, immediate 1000m descent, and Gamow hyperbaric bag.',
            steps: [
              'Rule of Golden Descent: If symptoms of ataxia (loss of balance) or breathlessness at rest occur, DESCEND AT LEAST 1000m IMMEDIATELY.',
              'Never ascend with symptoms of Acute Mountain Sickness (AMS); rest 24-48 hours and hydrate thoroughly.',
              'Use Portable Hyperbaric Chamber (Gamow Bag) pressurized to 2 psi if descent is delayed by snowstorms.',
              'Administer high-flow Oxygen and Dexamethasone (4-8mg) / Nifedipine as prescribed by mountain rescue physicians.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🔥 Chemical Plant BLEVE & Toxic Plume Evacuation (PESO)',
            accentColor: const Color(0xFFEF4444),
            summary: 'Boiling Liquid Expanding Vapor Explosion standoff distances and upwind evacuation.',
            steps: [
              'If a pressurized gas tanker or LPG sphere is impinged by flame and safety relief valve shrieks, EVACUATE AT LEAST 1000m IMMEDIATELY.',
              'Evacuate CROSSWIND / UPWIND from chemical vapor clouds; never run downwind in the plume axis.',
              'If caught in open thermal radiation: Drop prone behind solid concrete wall or embankment; cover head and exposed skin.',
              'Seal indoor living areas: Shut AC dampers, place damp towels beneath door crevices to block chlorine/ammonia ingress.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '✈️ Airport Runway Microburst & Low-Level Wind Shear (DGCA)',
            accentColor: const Color(0xFF0EA5E9),
            summary: 'Go-around directives, LLWAS alerts, and wind shear downdraft escape.',
            steps: [
              'If LLWAS announces Wind Shear Warning or airspeed drops > 15 knots on final approach, EXECUTE MAXIMUM-THRUST GO-AROUND IMMEDIATELY.',
              'Do not attempt low-altitude visual landings through localized convective thunderstorm downdrafts.',
              'Maintain runway clear zones and ground vehicle holdbacks during severe convective microburst warnings.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '👶 Hospital Neonatal ICU (NICU) Blackout Evacuation (MoHFW)',
            accentColor: const Color(0xFFF43F5E),
            summary: 'Transport incubators, phase-change warmers, and Kangaroo Mother Care (KMC) triage.',
            steps: [
              'Tier 1 (Ventilated Preterms): Mobilize battery-backed transport incubators with dedicated micro-O2 cylinders.',
              'Tier 2/3 (Stable Neonates): Initiate immediate skin-to-skin Kangaroo Mother Care (KMC) secured with chest binders.',
              'Never allow infant hypothermia: Wrap neonates in polyethylene thermal bags with woolen head caps.',
              'Label each infant with waterproof dual ID tags (wrist and ankle) and maternal biometric records.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🌊 River Embankment Piping & Sand Boil Mitigation (CWC)',
            accentColor: const Color(0xFF0284C7),
            summary: 'Bligh creep criteria, geotextile sandbag ring damming, and no-plugging rule.',
            steps: [
              'CRITICAL: NEVER plug a sand boil hole directly with clay or solid barriers (causes subsurface pressure buildup and explosive dyke blowout).',
              'Construct a concentric Sandbag Ring Barrier around the boil to raise headwater height until seepage water runs crystal clear.',
              'Place graded gravel/sand filter inside the ring to relieve hydrostatic pressure while trapping soil particles.',
              'Alert downstream disaster response teams if sand boil discharge turns muddy brown and exceeds 15 cm diameter.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🚛 Mountain Ghat Runaway Vehicle Escape Ramp (MoRTH / IRC)',
            accentColor: const Color(0xFFF59E0B),
            summary: 'Brake fade actions, arrester bed steering, and passenger brace posture.',
            steps: [
              'If heavy vehicle brakes fade or fail on steep mountain ghats, steer directly into the designated Gravel Escape Ramp.',
              'Keep steering straight and firmly centered; avoid sharp turning to prevent vehicular rollover.',
              'Do not downshift into neutral; maintain engine braking compression until full arrest in aggregate pea-gravel bed.',
              'Brace for impact: Passengers lean back firmly against seat cushions, tuck chin to chest, and grip armrests.',
            ],
          ),

          _buildPlaybookCard(
            context: context,
            title: '🎒 Emergency 72-Hour Go-Bag Checklist',
            accentColor: const Color(0xFF10B981),
            summary: 'Essential items needed for survival during emergency evacuation.',
            steps: [
              'Drinking water (3 liters per person) and water purification tablets / chlorine drops.',
              'High-calorie non-perishable dry foods (beaten rice / Chiura, nuts, glucose biscuits).',
              'First Aid kit, essential chronic medications, and emergency whistles.',
              'Waterproof pouch for citizenship/Aadhaar cards, passports, property deeds, and cash.',
              'High-power LED torch with extra batteries and charged power bank with cables.',
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPlaybookCard({
    required BuildContext context,
    required String title,
    required Color accentColor,
    required String summary,
    required List<String> steps,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            summary,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 12),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final text = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: accentColor, width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFFE2E8F0),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
