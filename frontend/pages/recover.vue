<template>
  <el-col :span="24" class="auth-page">
    <el-col :span="12">
      <h3 class="auth-page__name">Восстановление пароля</h3>
      <el-form
        ref="form"
        :model="form"
        :rules="rulesForm"
        label-position="top"
        size="small"
        @submit.native.prevent="submitForm"
      >
        <el-form-item
          label="Email"
          prop="email"
        >
          <el-input
            v-model="form.email"
            placeholder="Укажите email"
            :disabled="showCode"
          />
        </el-form-item>
        <el-form-item
          v-if="showCode"
          label="Код подтверждения"
          prop="code"
        >
          <el-input
            v-model="form.code"
            placeholder="Код подтверждения"
          />
        </el-form-item>
        <el-col class="flex-center">
          <el-button
            v-if="!showCode"
            type="primary"
            size="small"
            @click="sendCode"
          >
            Выслать код подтверждения
          </el-button>
          <el-button
            v-else
            type="primary"
            native-type="submit"
            size="small"
          >
            Войти
          </el-button>
        </el-col>
      </el-form>
      <el-col :span="24" style="padding-top: 15px;">
        <div class="text-center" style="padding-bottom: 10px;">
          <el-link
            :underline="false"
            @click="$router.push('/login')"
          >
            Авторизация
          </el-link>
        </div>
        <div class="text-center">
          <el-link
            :underline="false"
            @click="$router.push('/signup')"
          >
            Регистрация
          </el-link>
        </div>
      </el-col>
    </el-col>
  </el-col>
</template>
  
<script lang="ts">
import { ElForm } from 'element-ui/types/form'
import { Component, Vue, Ref, Action } from 'nuxt-property-decorator'
import { SuccessfulDataResponse } from '~/interfaces/responses'
import { ConfirmForm, MeForm, RegisterForm } from '~/interfaces/users'
import { validateEmail } from '~/utils/validate'
  
@Component({
  auth: 'guest',
  layout: 'auth',
  transition: 'slide-bottom',
})
export default class RecoverPage extends Vue {
  @Ref('form') formRef!: ElForm

  @Action('authUser/recover') recoverUser!: (data: Pick<ConfirmForm, 'email'>) => Promise<SuccessfulDataResponse<MeForm | null>>
  @Action('authUser/confirm') confirmUser!: (data: ConfirmForm) => Promise<SuccessfulDataResponse<MeForm | null>>

  form: ConfirmForm = this.getDefaultForm();
  rulesForm = {
    email: [
      { required: true, validator: this.validateEmail, trigger: 'blur' }
    ],
    code: [
      { required: true, message: 'Укажите код подтверждения', trigger: 'blur' },
    ]
  }
  showCode = false
  loading = false

  getDefaultForm () {
    return {
      email: '',
      code: ''
    }
  }

  beforeDestroy () {
    this.form = this.getDefaultForm()
  }

  validateEmail (_rule: Object, value: string, callback: Function) {
    validateEmail(value, callback)
  }

  confirm () {
    this.loading = true
    this.confirmUser(this.form)
    .then((response) => {
        if (response.data) {
          this.$auth.setUser(response.data.me)
          this.$auth.setUserToken(response.data.token)
        }
      }).finally(() => {
        this.loading = false
      })
  }

  recover () {
    this.loading = true
    const params = {
      email: this.form.email
    }
    this.recoverUser(params)
    .then(() => {
      this.showCode = true
    }).finally(() => {
      this.loading = false
    })
  }

  submitForm () {
    this.formRef.validate((valid) => valid && this.confirm())
  }

  sendCode () {
    this.formRef.validate((valid) => {
      if (!valid) return;
      this.recover()
    })
  }
}
</script>
  