import React from 'react';

const ListItem = ({source, quote, context}) => {
  return (
    <li>
      <p>{source} from {context}. "{quote}" </p>
    </li>
  )
}

export default ListItem;
