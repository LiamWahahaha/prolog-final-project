% default facts
customer(nicole).
restaurant(veg_r).
food(lentil_soup).
waiter(waitress).
cook(cook1).

% default observations
st_hpd(go(nicole, veg_r), true, 0).
st_hpd(order(nicole, lentil_soup, waitress), true, 1).
st_hpd(put_down(waitress, lentil_soup, t), true, 2).
st_hpd(eat(nicole, lentil_soup), true, 3).
st_hpd(leave(nicole), true, 4).

% questions
question(occur(leave(nicole))).
question(occur(pay(nicole, b))).
