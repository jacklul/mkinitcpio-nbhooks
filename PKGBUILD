pkgname=mkinitcpio-nbhooks
pkgver=master
pkgrel=1
pkgdesc='Hook that changes execution function of other hooks to run in a non-blocking way'
arch=('any')
url='https://github.com/jacklul/mkinitcpio-nbhooks'
license=('GPL')
makedepends=('git' 'sed')
backup=(etc/default/nbhooks.conf)
source=(install.sh config.conf)
md5sums=(SKIP SKIP)

pkgver() {
    set -o pipefail
    git describe --long --abbrev=7 2>/dev/null | sed 's/\([^-]*-g\)/r\1/;s/-/./g' ||
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short=7 HEAD)"
}

package() {
    install -Dm644 "config.conf"  "$pkgdir/etc/default/nbhooks.conf"
    install -Dm644 "install.sh"   "$pkgdir/usr/lib/initcpio/install/nbhooks"
}
