# @api private
class pcp::resources {

  create_resources('pcp::pmda', $pcp::pmdas)
  create_resources('pcp::pmie', $pcp::pmies)
  create_resources('pcp::pmlogger', $pcp::pmloggers)

}
