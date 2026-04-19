import React from 'react';
import ComponentTypes from '@theme-original/NavbarItem/ComponentTypes';
import type { ComponentTypesObject } from '@theme/NavbarItem/ComponentTypes';
import AISearchNavbar from '../../components/AISearchNavbar';

type CustomNavbarItemProps = {
  mobile?: boolean;
};

function AISearchNavbarItem({ mobile }: CustomNavbarItemProps): React.JSX.Element | null {
  if (mobile) {
    return null;
  }

  return <AISearchNavbar />;
}

export default {
  ...ComponentTypes,
  'custom-aiSearch': AISearchNavbarItem,
} satisfies ComponentTypesObject;
