import assert from 'assert';
import defaultPage from '../../pages/default';

describe('default page', function() {

  it('Testing the test functionality, this can be removed eventually', function () {
    let page = new defaultPage();
    assert.equal(page.test(), "Hello World");
  });

});
