# Firma y configuración local (Xcode)

1) Duplica el archivo de ejemplo:
    cp Config/Local.xcconfig.example Config/Local.xcconfig

2) Edita `Config/Local.xcconfig`:
- `DEVELOPMENT_TEAM_ID`: tu Team ID (Xcode → Settings → Accounts → tu Apple ID → copia el Team ID).
- `BUNDLE_ID_SUFFIX`: un sufijo único (p.ej. `.tuNombre`). Si compilas solo en simulador, puedes dejarlo vacío.

3) En Xcode:
- Project → Info → Configurations → asegúrate de que Debug usa `Config/Debug.xcconfig` y Release `Config/Release.xcconfig`.
- Target(s) → Build Settings → **Base Configuration** → selecciona el `Debug.xcconfig` / `Release.xcconfig` correspondiente (hazlo por cada target).

4) Simulator vs Dispositivo:
- **Simulator**: no requiere firma, debería compilar sin tocar nada más.
- **Dispositivo**: selecciona tu Team si Xcode lo pide (Signing & Capabilities), el bundle id ya incluirá tu sufijo.
