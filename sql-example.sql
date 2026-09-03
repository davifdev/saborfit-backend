CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- necessária para gen_random_uuid()

CREATE TABLE user (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now() 
);

CREATE INDEX idx_user_email ON user (email);

CREATE TYPE recipe_categories AS ENUM ('breakfast', 'lunch', 'snack', 'dinner');
CREATE TABLE recipe (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL REFERENCES user(id) ON DELETE CASCADE,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL, 
  cover_image_url TEXT NOT NULL,
  content TEXT NOT NULL,
  category recipe_categories,
  avg_rating NUMERIC(3, 2) NOT NULL DEFAULT 0,
  rating_count INTEGER NOT NULL DEFAULT 0,
  favorites_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()

  CONSTRAINT chk_avg_rating_range CHECK (avg_rating >= 0 AND avg_rating <= 5)
);

-- Indices que sustentam o feed (busca, filtros e ordenação)
CREATE INDEX idx_recipe_author_id ON recipe (author_id); -- Acelera qualquer query que filtra uma receita pelo author.
CREATE INDEX idx_recipe_created_at ON recipe (created_at DESC);
CREATE INDEX idx_recipe_avg_rating ON recipe (avg_rating DESC);
CREATE INDEX idx_recipe_category_created_at ON recipe (category, created_at DESC);
CREATE INDEX idx_recipe_search ON recipe USING GIN (to_tsvector('portuguese', title || ' ' || description));

CREATE TABLE comment (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL REFERENCES user(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES comment(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  deleted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_comment_recipe_id ON comment (recipe_id);
CREATE INDEX idx_comment_author_id ON comment (author_id);
CREATE INDEX idx_comment_parent_comment_id ON comment (parent_comment_id);

CREATE TABLE rating (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES user(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
  value SMALLINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_rating_value CHECK (value BETWEEN 1 AND 5),
  CONSTRAINT uq_rating_user_recipe UNIQUE (user_id, recipe_id)
);

CREATE INDEX idx_rating_recipe_id ON rating (recipe_id);

CREATE TABLE favorite (
  user_id UUID NOT NULL REFERENCES user(id) ON DELETE CASCADE,
  recipe_id UUID NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (user_id, recipe_id)
);

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$ 
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_updated_at
    BEFORE UPDATE ON user
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_recipe_updated_at
    BEFORE UPDATE ON recipe
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_comment_updated_at
    BEFORE UPDATE ON comment
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_rating_updated_at
    BEFORE UPDATE ON rating
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();
