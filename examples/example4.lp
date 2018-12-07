customer(nicole).
restaurant(veg_r).
food(lentil_soup).
food(miso_soup).
waiter(waitress).
cook(cook1).

st_hpd(go(nicole, veg_r), true, 0).
st_hpd(order(nicole, lentil_soup, waitress), true 1).
st_hpd(put_down(waitress, miso_soup, t), true, 2).
