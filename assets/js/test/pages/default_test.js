import assert from 'assert';
import chai from 'chai';
import defaultPage from '../../pages/default';

describe('default page', function() {

  it('Initializes the App', function () {
    let page = new defaultPage();
    assert.equal(page.test(), "Hello World");
  });

});
