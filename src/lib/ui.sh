info() { echo "ℹ️  $1"; }
success() { echo "✅ $1"; }
error() { echo "❌ Error: $1" >&2; exit 1; }
