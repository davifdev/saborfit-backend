import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import z from "zod";

import { AppController } from "./app.controller";
import { AppService } from "./app.service";
@Module({
  imports: [
    ConfigModule.forRoot({
      validationSchema: z.object({
        POSTGRES_USER: z.string().nonempty(),
        POSTGRES_PASSWORD: z.string().nonempty(),
        POSTGRES_DB: z.string().nonempty(),
      }),
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
