import React from 'react';
import './Header.css';
import { Link } from 'react-router-dom';

const Header = () => {
  return (
    <header>
      <h1 className='heading'>
        Sasta International Conference of Machine Learning
      </h1>
      <h4 className='subheading'>Designed by SPECTRUM</h4>
      <navbar>
        <div className='nav'>
          <ul className='nav_elements'>
            <Link to='/'>
              <li className='nav_item'>Home</li>
            </Link>
            <Link to='/team'>
              <li className='nav_item'>Team</li>
            </Link>
          </ul>
        </div>
      </navbar>
    </header>
  );
};

export default Header;
