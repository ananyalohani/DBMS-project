import './App.css';
import Homepage from './components/Homepage/Homepage';
import Header from './components/Header/Header';
import Team from './components/Team/Team.jsx';
import Footer from './components/Footer/Footer';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

function App() {
  return (
    <div className='App'>
      <Router>
        <Header />
        <div className='app_body'>
          <Switch>
            <Route path='/team'>
              <Team />
            </Route>
            <Route path='/'>
              <Homepage />
            </Route>
          </Switch>
        </div>
        <Footer />
      </Router>
    </div>
  );
}

export default App;
