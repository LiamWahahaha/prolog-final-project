customer(nicole).
restaurant(veg_r).
food(lentil_soup).

st_hpd(go(nicole, veg_r), true, 0).
st_hpd(sit(nicole), true, 1).
st_hpd(pick_up(nicole, m, t), true, 2).
st_obs(available(lentil_soup, veg_r), false, 3).
next_st(2, 3).
