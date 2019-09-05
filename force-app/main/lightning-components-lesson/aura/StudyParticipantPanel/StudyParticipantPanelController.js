/**
 * Created by user on 05.09.2019.
 */

({
  doInit: function(component, event, helper) {
    component.set('v.filter', {
      status: '',
      studyTitleTerm: ''
    })
  },
  updateTable: function(component, event, helper) {
    alert('Update table action');
  }
});