-- Michael's on the Hill is no longer a restaurant.
-- Hide it everywhere by marking the row inactive. The row stays in place.
-- Safe to paste again.

update public.recommendations
set is_active = false
where name = $n$Michael's on the Hill$n$
  and is_active;

notify pgrst, 'reload schema';
