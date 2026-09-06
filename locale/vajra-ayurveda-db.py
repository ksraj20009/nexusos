#!/usr/bin/env python3
"""
Vajra OS Ayurveda Database - herbs, remedies, doshas, diet tips.
"""

AYURVEDA_DB = {
    "doshas": {
        "Vata": {"elements": "Air + Space", "qualities": "Dry, light, cold, rough", "balance": "Warm, moist, grounding foods; regular routine"},
        "Pitta": {"elements": "Fire + Water", "qualities": "Hot, sharp, oily, intense", "balance": "Cooling foods; moderate exercise; avoid spicy"},
        "Kapha": {"elements": "Earth + Water", "qualities": "Heavy, slow, cold, moist", "balance": "Light, warm foods; vigorous exercise"},
    },
    "herbs": {
        "Ashwagandha": {"use": "Stress, energy, immunity", "dosha": "Vata, Kapha", "form": "Powder, capsule"},
        "Brahmi": {"use": "Memory, concentration", "dosha": "Vata, Pitta", "form": "Powder, oil"},
        "Tulsi (Holy Basil)": {"use": "Respiratory, immunity", "dosha": "All", "form": "Tea, leaves"},
        "Triphala": {"use": "Digestion, detox", "dosha": "All", "form": "Powder, tablet"},
        "Turmeric (Haldi)": {"use": "Inflammation, immunity, skin", "dosha": "All", "form": "Powder, root"},
        "Neem": {"use": "Skin, blood purification", "dosha": "Pitta, Kapha", "form": "Powder, oil"},
        "Ginger (Adrak)": {"use": "Digestion, nausea, cold", "dosha": "Vata, Kapha", "form": "Fresh, dried"},
        "Amla": {"use": "Vitamin C, immunity, hair", "dosha": "All", "form": "Fresh, juice"},
        "Shatavari": {"use": "Female health, fertility", "dosha": "Vata, Pitta", "form": "Powder"},
        "Shilajit": {"use": "Energy, stamina, anti-aging", "dosha": "All", "form": "Resin"},
    },
    "remedies": {
        "Common Cold": "Ginger tea with honey; steam inhalation; rest",
        "Cough": "Turmeric milk (haldi doodh); licorice tea; honey with ginger",
        "Indigestion": "Triphala at night; fennel tea; avoid cold drinks",
        "Headache": "Peppermint oil on temples; ginger tea; hydration",
        "Insomnia": "Ashwagandha before bed; warm milk with nutmeg; oil massage",
        "Acne": "Neem paste; turmeric + honey mask; avoid oily food",
        "Hair Loss": "Amla oil massage; bhringraj; adequate protein",
        "Joint Pain": "Turmeric + milk; ashwagandha; gentle yoga",
        "Stress": "Brahmi tea; meditation; ashwagandha; sleep",
        "Low Immunity": "Tulsi tea daily; chyawanprash; amla; rest",
    },
    "diet_tips": {
        "Vata": "Warm, cooked foods; ghee; root vegetables; nuts; avoid raw/cold",
        "Pitta": "Cooling foods; cucumber; coconut; sweet fruits; avoid spicy/salty",
        "Kapha": "Light, warm foods; spices; legumes; avoid dairy/heavy foods",
    },
}

def main():
    print("=" * 55)
    print("  Vajra OS Ayurveda Database")
    print("=" * 55)
    print("\n  1. Doshas  2. Herbs  3. Remedies  4. Diet Tips  5. Search  6. Exit")
    while True:
        choice = input("\n  Choice: ").strip()
        if choice == "1":
            print("\n  --- Doshas ---")
            for name, info in AYURVEDA_DB["doshas"].items():
                print(f"\n  {name} ({info['elements']})")
                print(f"    Qualities: {info['qualities']}")
                print(f"    Balance:   {info['balance']}")
        elif choice == "2":
            print("\n  --- Herbs ---")
            for name, info in AYURVEDA_DB["herbs"].items():
                print(f"\n  {name}: {info['use']} (Dosha: {info['dosha']}, Form: {info['form']})")
        elif choice == "3":
            print("\n  --- Remedies ---")
            for ailment, remedy in AYURVEDA_DB["remedies"].items():
                print(f"\n  {ailment}: {remedy}")
        elif choice == "4":
            print("\n  --- Diet Tips ---")
            for dosha, tips in AYURVEDA_DB["diet_tips"].items():
                print(f"\n  {dosha}: {tips}")
        elif choice == "5":
            query = input("  Search: ").strip().lower()
            found = False
            for section in AYURVEDA_DB.values():
                for key, val in section.items():
                    if query in key.lower() or (isinstance(val, dict) and any(query in str(v).lower() for v in val.values())):
                        print(f"  Found: {key}")
                        if isinstance(val, dict):
                            for k, v in val.items(): print(f"    {k}: {v}")
                        else: print(f"    {val}")
                        found = True
            if not found: print("  No results found.")
        elif choice == "6":
            break
        if choice != "6":
            print("\n  Disclaimer: For informational purposes only. Consult a qualified practitioner.")

if __name__ == "__main__":
    main()