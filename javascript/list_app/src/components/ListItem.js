import React from 'react';

const ListItem = ({source, quote, context}) => {
  return (
    <li>
      <div>
        <p>{source} from {context}. "{quote}" </p>
      </div>
    </li>
  )
}

export default ListItem;
