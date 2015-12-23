# Private class: See README.md.
class pcp::install {

  $_main_packages = [$pcp::package_name]
  $_packages = union($_main_packages, $pcp::extra_packages)

  ensure_packages($_packages)

}
