-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "avatar_url" TEXT,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recipe" (
    "id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "description" TEXT NOT NULL,
    "cover_image_url" TEXT,
    "content" TEXT NOT NULL,
    "avg_rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "rating_count" INTEGER NOT NULL DEFAULT 0,
    "favorites_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "recipe_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "chk_avg_rating_range" CHECK ("avg_rating" >= 0 AND "avg_rating" <= 5)
);

CREATE INDEX idx_recipe_search ON recipe
    USING GIN (to_tsvector('portuguese', title || ' ' || description));

-- CreateTable
CREATE TABLE "comment" (
    "id" UUID NOT NULL,
    "author_id" UUID NOT NULL,
    "recipe_id" UUID NOT NULL,
    "parent_comment_id" UUID,
    "content" TEXT NOT NULL,
    "deleted_at" TIMESTAMPTZ(6),
    "created_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rating" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "recipe_id" UUID NOT NULL,
    "value" SMALLINT NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rating_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favorite" (
    "user_id" UUID NOT NULL,
    "recipe_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "favorite_pkey" PRIMARY KEY ("user_id","recipe_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE INDEX "idx_recipe_author_id" ON "recipe"("author_id");

-- CreateIndex
CREATE INDEX "idx_recipe_created_at" ON "recipe"("created_at" DESC);

-- CreateIndex
CREATE INDEX "idx_recipe_avg_rating" ON "recipe"("avg_rating" DESC);

-- CreateIndex
CREATE INDEX "idx_comment_recipe_id" ON "comment"("recipe_id");

-- CreateIndex
CREATE INDEX "idx_comment_author_id" ON "comment"("author_id");

-- CreateIndex
CREATE INDEX "idx_comment_parent_comment_id" ON "comment"("parent_comment_id");

-- CreateIndex
CREATE INDEX "idx_rating_recipe_id" ON "rating"("recipe_id");

-- CreateIndex
CREATE UNIQUE INDEX "uq_rating_user_id_recipe_id" ON "rating"("user_id", "recipe_id");

-- CreateIndex
CREATE INDEX "idx_favorite_recipe_id" ON "favorite"("recipe_id");

-- AddForeignKey
ALTER TABLE "recipe" ADD CONSTRAINT "recipe_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_recipe_id_fkey" FOREIGN KEY ("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comment" ADD CONSTRAINT "comment_parent_comment_id_fkey" FOREIGN KEY ("parent_comment_id") REFERENCES "comment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rating" ADD CONSTRAINT "rating_recipe_id_fkey" FOREIGN KEY ("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favorite" ADD CONSTRAINT "favorite_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favorite" ADD CONSTRAINT "favorite_recipe_id_fkey" FOREIGN KEY ("recipe_id") REFERENCES "recipe"("id") ON DELETE CASCADE ON UPDATE CASCADE;

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_user_updated_at
    BEFORE UPDATE ON "user"
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_recipe_updated_at
    BEFORE UPDATE ON recipe
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_comment_updated_at
    BEFORE UPDATE ON "comment"
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_rating_updated_at
    BEFORE UPDATE ON rating
    FOR EACH ROW EXECUTE FUNCTION set_updated_at();