(function() {
  'use strict';

  angular.module('app.resources')
    .factory('Staff', StaffFactory);

  /** @ngInject */
  function StaffFactory($resource) {
    var Staff = $resource('/api/v1/staff/:id', {id: '@id'}, {
      // Get Current
      getCurrentMember: {
        method: 'GET',
        isArray: false,
        url: '/api/v1/staff/current_member'
      },
      // Get Single
      get: {
        method: 'GET',
        isArray: false
      },
      // Get All
      query: {
        method: 'GET',
        isArray: true
      },
      'update': {
        method: 'PUT'
      }
    });

    Staff.prototype.fullName = fullName;

    function fullName() {
      /*jshint validthis: true */
      return [this.first_name, this.last_name].join(' ');
    }

    return Staff;
  }
})();
