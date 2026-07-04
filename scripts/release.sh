#!/usr/bin/env bash
#
# CoBang release script
# Usage: ./scripts/release.sh 2.6.0
#
set -euo pipefail

VERSION="${1:?Usage: $0 <version> (e.g. 2.6.0)}"
TAG="v${VERSION}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO_ROOT"

# ── Sanity checks ──────────────────────────────────────────────────────────

if ! git diff --stat --exit-code; then
    echo "ERROR: Working tree has uncommitted changes. Commit or stash first."
    exit 1
fi

if ! git diff --cached --stat --exit-code; then
    echo "ERROR: Staged but uncommitted changes. Commit first."
    exit 1
fi

if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "ERROR: Tag $TAG already exists."
    exit 1
fi

# ── Verify versions match ──────────────────────────────────────────────────

check_version() {
    local file="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$file"; then
        echo "WARNING: Version $VERSION not found in $file (pattern: $pattern)"
    fi
}

check_version "meson.build" "version: '$VERSION'"
check_version "pyproject.toml" "version = \"$VERSION\""
check_version "data/vn.hoabinh.quan.CoBang.metainfo.xml.in" "release version=\"$VERSION\""
check_version "snap/snapcraft.yaml" "version: '$VERSION'"

# ── Build ───────────────────────────────────────────────────────────────────

echo "=== Building with meson ==="
meson setup _build_release --wipe 2>/dev/null || meson setup _build_release
ninja -C _build_release
echo "Build OK"

# ── Create tarball ──────────────────────────────────────────────────────────

echo "=== Creating source tarball ==="
git archive --format=tar.gz --prefix="cobang-${VERSION}/" -o "cobang-${VERSION}.tar.gz" HEAD
echo "Tarball: cobang-${VERSION}.tar.gz ($(du -h "cobang-${VERSION}.tar.gz" | cut -f1))"

# ── Create tag ──────────────────────────────────────────────────────────────

echo "=== Creating tag ${TAG} ==="
git tag -a "$TAG" -m "CoBang v${VERSION}

- Screen share live-feed mode via Portal ScreenCast (Wayland) or ximagesrc (X11)
- Screenshot capture via Portal Screenshot API
- Desktop notification with click-to-focus when QR code detected
- Floating point exception and heap corruption crash fixes
- zbar-py migration and thread-safety fixes"

echo ""
echo "=== Release ${TAG} ready ==="
echo ""
echo "Next steps:"
echo "  1. Review and push: git push origin ${TAG}"
echo "  2. GitHub will auto-create the release from the tag"
echo "  3. Upload cobang-${VERSION}.tar.gz to the GitHub release"
echo ""
echo "To publish on PyPI:"
echo "  python -m build && twine upload dist/cobang-${VERSION}.tar.gz"
