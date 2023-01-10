<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up(): void
    {
        Schema::create('projects', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->longText('description');
            $table->text('coverage')->nullable();
            $table->boolean('is_active')->default(true);
            $table->foreignId('author')->constrained('users');
            $table->timestamps();
        });

        Schema::create('category_project', function (Blueprint $table) {
            $table->foreignId('category_id')->constrained('categories');
            $table->foreignId('project_id')->constrained('projects');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down(): void
    {
        Schema::dropIfExists('category_project');
        Schema::dropIfExists('projects');
    }
};
