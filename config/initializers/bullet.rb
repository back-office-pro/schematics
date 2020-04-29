Bullet.enable = true
# TODO
# remove unused_eager_loading_enable if https://github.com/flyerhzm/bullet/issues/147
# and https://github.com/flyerhzm/bullet/issues/467 are fixed
Bullet.unused_eager_loading_enable = false
Bullet.raise = !Rails.env.production?
Bullet.bullet_logger = Rails.env.production?
