import { serve } from "https://deno.land/std@0.177.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-client@2.39.8?target=deno"
import { JWT } from "https://esm.sh/google-auth-library@9.4.1?target=deno"

serve(async (req: Request) => {
  try {
    const { record } = await req.json()

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { data: receiver } = await supabase
      .from('users')
      .select('fcm_token')
      .eq('id', record.receiver_id)
      .single()

    if (!receiver?.fcm_token) return new Response("No token", { status: 200 })

    const serviceAccount = JSON.parse(Deno.env.get('FIREBASE_SERVICE_ACCOUNT')!)

    const jwtClient = new JWT(
      serviceAccount.client_email,
      null,
      serviceAccount.private_key,
      ['https://www.googleapis.com/auth/cloud-platform']
    )
    
    const tokens = await jwtClient.authorize()

    const fcmResponse = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${tokens.access_token}`,
        },
        body: JSON.stringify({
          message: {
            token: receiver.fcm_token,
            notification: {
              title: "New Message",
              body: record.message_text,
            },
            data: {
              conversation_id: record.conversation_id,
            }
          }
        }),
      }
    )

    const result = await fcmResponse.json()
    return new Response(JSON.stringify(result), { status: 200 })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})