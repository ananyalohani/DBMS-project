import React from 'react';
import members from './team.json';
import styled, { css } from 'styled-components';

const Team = () => {
  const bg = '#FFF';
  const accent0 = '#095caa';
  const accent1 = '#044c8f';
  const accent2 = '#03325e';

  const Heading = styled.h1`
    color: ${accent1};
    margin-bottom: 0;
  `;

  const SubHeading = styled.h2`
    color: ${accent2};
    margin-top: 0;
    font-weight: 400;
  `;

  const CardGrid = styled.div`
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
  `;

  const Card = styled.div`
    background: ${bg};
    box-shadow: 0px 3px 10px 5px rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    margin: 20px;
    padding: 10px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    color: ${accent0};

    &:first-of-type {
      margin-left: 0;
    }
  `;

  const Avatar = styled.img`
    width: 150px;
  `;

  const Name = styled.a`
    color: ${accent2};
    margin-top: 5px;
    text-align: center;
    text-decoration: none;
    font-weight: 700;
    transition: 0.2s all ease-in-out;

    &.hover {
      text-decoration: underline;
    }
  `;

  const Desc = styled.p`
    color: ${accent1};
    font-weight: 400;
    font-size: 13px;
    text-align: center;
    margin: 0;
  `;
  return (
    <div className='team'>
      <Heading> Spectrum </Heading>
      <SubHeading>Members</SubHeading>
      <CardGrid>
        {members.map((member) => (
          <Card>
            <Avatar src={member.image} />
            <Name href={member.link}>{member.name}</Name>
            <Desc>
              {member.rollNumber}
              <br />
              {member.branch}
            </Desc>
          </Card>
        ))}
      </CardGrid>
    </div>
  );
};
export default Team;
