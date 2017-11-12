import defaultPage from '../../js/pages/default';

test('#testing()', () => {
  let page = new defaultPage();
  expect(page.testing()).toBe("TODO: Testing Pages is going to be hard with lots of mocks for sockets, services and the DOM");
});

// testing react apps
// https://facebook.github.io/jest/docs/en/tutorial-react.html#setup-without-create-react-app

