@bearsNg.directive 'ttIpOrFqdn', [ ->
  restrict: "A",
  require: 'ngModel'
  link: (scope, elm, attrs, ctrl) ->
    ctrl.$validators.ip_or_fqdn = (modelValue,viewValue) ->
      IP_REGEX = /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
      FQDN_REGEX = /^(?=.{1,254}$)((?=[a-z0-9-]{1,63}\.)(xn--+)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}$/i
      if IP_REGEX.test(viewValue) || FQDN_REGEX.test(viewValue)
        return true
      return false
]