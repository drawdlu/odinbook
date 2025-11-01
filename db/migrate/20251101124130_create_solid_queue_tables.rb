class CreateSolidQueueTables < ActiveRecord::Migration[8.0]
  def change
    # Main jobs table
    create_table :solid_queue_jobs do |t|
      t.string :queue_name, null: false
      t.string :priority, null: false
      t.string :job_class, null: false
      t.text :arguments
      t.string :active_job_id
      t.integer :executions_count, null: false, default: 0
      t.text :exception_details
      t.datetime :scheduled_at
      t.datetime :finished_at
      t.string :status, null: false
      t.datetime :created_at, null: false
    end
    add_index :solid_queue_jobs, [ :queue_name, :priority, :created_at ], name: "sq_jobs_queue_priority_created"
    add_index :solid_queue_jobs, :scheduled_at
    add_index :solid_queue_jobs, :status

    # Other necessary tables for Solid Queue functionality
    create_table :solid_queue_claims do |t|
      t.references :job, index: true, null: false
      t.references :process, index: true, null: false
      t.datetime :created_at, null: false
    end
    add_foreign_key :solid_queue_claims, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_index :solid_queue_claims, [ :job_id, :process_id ], unique: true

    create_table :solid_queue_pauses do |t|
      t.string :queue_name, null: false
      t.datetime :created_at, null: false
    end
    add_index :solid_queue_pauses, :queue_name, unique: true

    create_table :solid_queue_processes do |t|
      t.text :metadata
      t.integer :supervisor_id
      t.datetime :created_at, null: false
      t.datetime :last_heartbeat_at, null: false
    end
    add_index :solid_queue_processes, :last_heartbeat_at

    create_table :solid_queue_blocked_executions do |t|
      t.references :job, index: true, null: false
      t.string :reason, null: false
      t.datetime :created_at, null: false
    end
    add_foreign_key :solid_queue_blocked_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_index :solid_queue_blocked_executions, :created_at

    create_table :solid_queue_failed_executions do |t|
      t.references :job, index: true, null: false
      t.text :error
      t.datetime :created_at, null: false
    end
    add_foreign_key :solid_queue_failed_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade
    add_index :solid_queue_failed_executions, :created_at

    create_table :solid_queue_scheduled_executions do |t|
      t.references :job, index: true, null: false
      t.string :scheduled_at, null: false, index: true
      t.datetime :created_at, null: false
    end
    add_foreign_key :solid_queue_scheduled_executions, :solid_queue_jobs, column: :job_id, on_delete: :cascade

    create_table :solid_queue_semaphores do |t|
      t.string :key, null: false
      t.integer :value, null: false, default: 1
      t.datetime :expires_at, null: false
      t.datetime :created_at, null: false
    end
    add_index :solid_queue_semaphores, :key, unique: true
    add_index :solid_queue_semaphores, :expires_at
  end
end
