provider "kubernetes" {
  config_path    = var.KUBE_CONFIG_PATH
  config_context = var.KUBE_CONTEXT
}

resource "kubernetes_secret" "aws_key" {
  metadata {
    name      = "aws-key"
    namespace = var.STACK_NAME
  }

  data = {
    AWS_SECRET_ACCESS_KEY = var.AWS_SECRET_KEY
  }

  type = "Opaque"
}

resource "kubernetes_job" "set_ts" {
  metadata {
    name      = "set-st"
    namespace = var.STACK_NAME
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "aws-cli"
          image   = "amazon/aws-cli:latest"
          command = ["/bin/sh", "-c"]
          args    = ["echo $NOW_TS | aws --endpoint-url=http://$STACK_NAME:4566 s3 cp - s3://$S3_BUCKET/timestamp.txt"]

          env {
            name  = "AWS_ACCESS_KEY_ID"
            value = var.AWS_ACCESS_KEY
          }

          env {
            name  = "AWS_DEFAULT_REGION"
            value = var.AWS_REGION
          }

          env {
            name  = "S3_BUCKET"
            value = aws_s3_bucket.ts_bucket.bucket
          }

          env {
            name  = "NOW_TS"
            value = local.now_ts
          }

          env {
            name  = "STACK_NAME"
            value = var.STACK_NAME
          }

          env_from {
            secret_ref {
              name = kubernetes_secret.aws_key.metadata[0].name
            }
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          image_pull_policy = "IfNotPresent"
        }
        restart_policy = "OnFailure"
      }
    }
    backoff_limit = 3
  }
  wait_for_completion = true
  timeouts {
    create = "2m"
    update = "2m"
  }

  depends_on = [aws_s3_bucket.ts_bucket]
}
